-- helper functions
function split_str(str, delim)
   str = str or ''
   delim = string.format('[^%s]+', (delim or '%s'))
   local tbl = {}
   for line in string.gmatch(str, delim) do table.insert(tbl, line) end
   return tbl
end
function clean_str(str)
   return str:gsub('((^%s)|(%s$))+', ''):gsub('[\n\r]+', '\n')
end
function make_set(tbl)
   local set = {}
   for _,row in pairs(tbl) do set[row] = true end
   return set
end
function check_dryrun(description, func, success)
   if not quiet
   then print(description)
   end

   if dryrun
   then return success
   else func()
   end
end
function os.capture(cmd, raw)
   local f = assert(io.popen(cmd, 'r'))
   local s = assert(f:read('*a'))
   f:close()

   if raw
   then return s
   else return clean_str(s)
   end
end
function os.chroot(cmd)
   if cmd == nil
   then cmd = ''
   end

   local chroot_cmd = string.format(
      'arch-chroot /mnt %q',
      cmd:gsub('"', '\\"')
   )
   local chroot_func = function() return os.execute(chroot_cmd) end
   return check_dryrun(chroot_cmd, chroot_func, 0)
end

-- global variables
disks = make_set(split_str(
   os.capture(string.format(
      '%s | %s | %s | %s',
      'fdisk -l', 'grep -i \'disk\'',
      'awk -F \':\' \'{ print $1 }\'', 'awk \'{ print $2 }\''
   )),
   "\n"
))
schema = {}
parted_cmd = 'parted --align optimal --script'
architecture = os.capture(
   'lscpu | grep -i \'architecture\' | awk \'{ print $2 }\''
)
usage = string.format(
   'usage: %s [ %s [ %s [ ... ] ] ]',
   arg[0], 'option=argument', 'option=argument'
)
options = {
   help = {
      short='-h', full='--help',
      description='display this message and exit.'
   },
   dryrun = {
      short='-d', full='--dryrun',
      description='do not execute operating system commands.'
   },
   quiet = {
      short='-q', full='--quiet',
      description='do not print status during installation.'
   },
   file = {
      short='-f', full='--file',
      description='set the filename of the partition schema.'
   },
   host = {
      short='-h', full='--hostname',
      description='set the hostname of the machine.'
   },
   time = {
      short='-t', full='--timezone',
      description='set the timezone of the machine'
   },
   lang = {
      short='-l', full='--language',
      description='set the languages to be installed.'
   },
   pass = {
      short='-p', full='--password',
      description='set the password of the root user.'
   }
}
dryrun = false
quiet = false
partition_file = './partition_schema'
hostname = string.format('arch-%s', architecture)
timezone = 'America/Los_Angeles'
language = 'en_US.UTF-8'
password = 'feedface'

function cmd_line()
   function print_options()
      print('options:')
      for _,op in pairs(options) do
         print(string.format(
            '   %s | %-10s: %s',
            op['short'], op['full'], op['description']
         ))
      end
   end

   for ndx=1,# arg do
      local cmd = split_str(arg[ndx], '=')
      local form
      if string.find(cmd[1], '--') ~= nil
      then form = 'full'
      else form = 'short'
      end

      for key,val in pairs(options) do
         if cmd[1] == val[form] then
            if key == 'help' then
               print(usage)
               print_options()
               os.exit(0)
            elseif key == 'dryrun' then
               if cmd[2] == nil
               then dryrun = true
               else dryrun = not not cmd[1]
               end
            elseif key == 'file' then partition_file = cmd[2]
            elseif key == 'host' then hostname = cmd[2]
            elseif key == 'time' then timezone = cmd[2]
            elseif key == 'lang' then language = cmd[2]
            elseif key == 'pass' then password = cmd[2]
            else
               print(string.format(
                  'unrecognized option "%s".\n%s\nexiting...',
                  key, usage
               ))
               os.exit(1)
            end
         end
      end
   end
end

function make_schema()
   function make_schema_row(str)
      local rows = split_str(str, ' ')
      return {
         disk=rows[1],
         part_type=rows[2],
         size=rows[3],
         fs=rows[4],
         name=rows[5],
         mount=rows[6],
         flags=split_str(rows[7], ',')
      }
   end

   local fstr = assert(io.open(partition_file, 'r'))
   local str = clean_str(fstr:read('*all'))
   fstr:close()

   local rows = split_str(str, '\n')
   for _,row in pairs(rows) do
      local schema_row = make_schema_row(row)
      if schema_row['size'] ~= 0 then
         table.insert(schema, schema_row)
      end
   end

   local disk_count = {}
   for ndx=1,# schema do
      local row = schema[ndx]

      if disk_count[row['disk']]
      then disk_count[row['disk']] = disk_count[row['disk']] + 1
      else disk_count[row['disk']] = 1
      end

      schema[ndx]['part_num'] = disk_count[row['disk']]
   end
end
function create_partition_tables()
   local initialized_labels = {}

   for _,row in pairs(schema) do
      if not disks[row['disk']] then
         print(string.format('disk %s not found. exiting...', row['disk']))
         os.exit(1)
      elseif not initialized_labels[row['disk']] then
         local label_cmd = string.format(
            '%s %s mklabel gpt',
            parted_cmd, row['disk']
         )
         local label_func = function() return os.execute(label_cmd) end
         if check_dryrun(label_cmd, label_func, 0) == 0 then
            initialized_labels[row['disk']] = true
         else
            print(string.format(
               'could not make gpt label for disk %s. exiting...',
               row['disk']
            ))
            os.exit(1)
         end
      end
   end
end
function create_partitions()
   function get_error_message(cmd_str, row)
      string.format(
         'could not %s partition (%s %d %s %s) on disk %s',
         row['part_type'], row['size'], row['fs'], row['name'], row['disk']
      )
   end

   local part_start = 0
   local part_stop

   for _,row in pairs(schema) do
      part_stop = part_start + row['size']

      -- make partition
      local partition_cmd = string.format('%s mkpart %s %d %d',
       parted_cmd, row['part_type'], part_start, part_stop)
      local partition_func = function() return os.execute(partition_cmd) end
      if check_dryrun(partition_cmd, partition_func, 0) ~= 0 then
         print(get_error_message('make', row))
         os.exit(1)
      end

      part_start = part_stop + row['size']

      -- name partition
      local name_cmd = string.format('%s name %d %s',
       parted_cmd, row['part_num'], row['name'])
      local name_func = function() return os.execute(name_cmd) end
      if check_dryrun(name_cmd, name_func, 0) ~= 0 then
         print(get_error_message('name', row))
         os.exit(1)
      end

      -- set flags
      for _,flag in pairs(row['flags']) do
         local flag_cmd = string.format('%s set %d %s on',
          parted_cmd, row['part_num'], flag)
         local flag_func = function() return os.execute(flag_cmd) end
         if check_dryrun(flag_cmd, flag_func, 0) ~= 0 then
            print(get_error_message(
               string.format('set flag "%s"', flag), row)
            )
            os.exit(1)
         end
      end

      -- format partitions
      local format_cmd
      if row['fs'] == 'swap' then
         format_cmd = string.format(
            'mkswap %s%d',
            row['disk'], row['part_num']
         )
      elseif row['fs'] ~= 'grub' then
         format_cmd = string.format(
            'mkfs.%s %s%d',
            row['fs'], row['disk'], row['part_num']
         )
      end
      local format_func = function() return os.execute(format_cmd) end
      if format_cmd and check_dryrun(format_cmd, format_func, 0) ~= 0 then
         print(get_error_message('format', row))
         os.exit(1)
      end
   end
end
function mount_filesystems()
   table.sort(schema, function(a, b) return a['mount'] < b['mount'] end)
   for _,row in pairs(schema) do
      if row['mount'] ~= 'swap' and row['mount'] ~= 'grub' then
         local dir = string.format('/mnt%s', row['mount'])

         local mkdir_cmd = string.format('mkdir -p %s', dir)
         local mkdir_func = function() return os.execute(mkdir_cmd) end
         if check_dryrun(mkdir_cmd, mkdir_func, 0) ~= 0 then
            print(string.format(
               'could not make directory "%s". exiting...',
               dir
            ))
            os.exit(1)
         end

         local mount_cmd = string.format(
            'mount %s%d %s',
            row['disk'], row['part_num'], dir
         )
         local mount_func = function() return os.execute(mount_cmd) end
         if check_dryrun(mount_cmd, mount_func, 0) ~= 0 then
            print(string.format(
               'could not mount %s%d at "%s". exiting...',
               row['disk'], row['part_num'], dir
            ))
            os.exit(1)
         end
      end
   end
end

function partition()
   make_schema()
   create_partition_tables()
   create_partitions()
   mount_filesystems()
end
function install()
   -- base installation
   local base_cmd = 'pacstrap /mnt base base-devel grub-bios'
   local base_func = function() return os.execute(base_cmd) end
   if check_dryrun(base_cmd, base_func, 0) ~= 0 then
      print('could not install base system. exiting...')
      os.exit(1)
   end

   -- generate fstab
   local fstab_cmd = 'genfstab -p /mnt >> /mnt/etc/fstab'
   local fstab_func = function() return os.execute(fstab_cmd) end
   if check_dryrun(fstab_cmd, fstab_func, 0) ~= 0 then
      print('could not generate fstab. exiting...')
      os.exit(1)
   end

   -- set hostname
   local hostname_cmd = string.format('echo %s /mnt/etc/hostname', hostname)
   local hostname_func = function() return os.execute(hostname_cmd) end
   if check_dryrun(hostname_cmd, hostname_func, 0) ~= 0 then
      print('could not set hostname. exiting...')
      os.exit(1)
   end

   -- set timezone
   local timezone_cmd = string.format(
      'ln -sf /mnt/usr/share/zoneinfo/%s /mnt/etc/localtime',
      timezone
   )
   local timezone_func = function() return os.execute(timezone_cmd) end
   if check_dryrun(timezone_cmd, timezone_func, 0) ~= 0 then
      print('could not set timezone. exiting...')
      os.exit(1)
   end

   -- generate locale
   local locale_cmd = string.format(
      'sed -i \'s/^#%s/%s/g\' /etc/locale.gen; locale-gen',
      language, language
   )
   if os.chroot(locale_cmd) ~= 0 then
      print('could not set locale. exiting...')
      os.exit(1)
   end

   -- create initial ramdisk
   if os.chroot('mkinitcpio -p linux') ~= 0 then
      print('could not create initial ramdisk. exiting...')
      os.exit(1)
   end

   -- install bootloader
   local bootloader_cmd = string.format('%s; %s; %s; %s',
      'modprobe dm-mod',
      'grub-install /dev/sda',
      string.format('cp %s %s',
         '/usr/share/locale/en@quot/LC_MESSAGES/grub.mo',
         '/boot/grub/locale/en.mo; '
      ),
      'grub-mkconfig -o /boot/grub/grub.cfg'
   )
   if os.chroot(bootloader_cmd) ~= 0 then
      print('could not install bootloader. exiting...')
      os.exit(1)
   end

   -- set root password
   local passwd_cmd = string.format('echo \'root:%s\' | chpasswd', password)
   if os.chroot(passwd_cmd) ~= 0 then
      print('could not set root password. exiting...')
      os.exit(1)
   end
end
function clean()
   -- dismount filesystems
   table.sort(schema, function(a, b) return a['mount'] > b['mount'] end)
   for _,row in pairs(schema) do
      if row['mount'] ~= 'swap' and row['mount'] ~= 'grub' then
         local dir = string.format('/mnt%s', row['mount'])
         local umount_cmd = string.format('umount %s', dir)
         local umount_func = function() return os.execute(umount_cmd) end
         if check_dryrun(umount_cmd, umount_func, 0) ~= 0 then
            print(string.format(
               'could not dismount filesystem %s%d at "%s". exiting...',
               row['disk'], row['part_num'], row['mount']
            ))
            os.exit(1)
         end
      end
   end
end

cmd_line()
partition()
install()
clean()
print('installation completed without errors.')
