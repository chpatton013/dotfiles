-- helper functions
function split_str(str, delim)
   local t = {}
   for line in string.gmatch(str, delim) do table.insert(t, line) end
   return t
end
function clean_str(str)
   return str:gsub('((^%s)|(%s$))+', ''):gsub('[\n\r]+', '\n')
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
function make_set(table)
   local set = {}
   for item in table do table.insert(set, item, true) end
   return set
end
function chroot(cmd)
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
function check_dryrun(description, func, success)
   if not quiet
   then print(description)
   end

   if dryrun
   then return success
   else func()
   end
end

-- global variables
disks = make_set(split_str(
   os.capture('fdisk -l | awk -F ":" "{ print $1 }" | awk "{ print $2 }"'),
   "\n"
))
schema = {}
parted_cmd = 'parted -a optimize --script'
architecture = os.capture('lscpu | grep -i "architecture" | awk "{ print $2 }"')
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
      for op in options do
         print(string.format(
            '   %s | %-10s: %s',
            op['short'], op['full'], op['description']
         ))
      end
   end

   for ndx=1,# arg do
      local cmd = split_str(arg[ndx], '=')
      local form
      if string.find(cmd[0], '--') ~= nil
      then form = 'full'
      else form = 'short'
      end

      table.foreach(options, function(key, val)
         if cmd[0] == val[form] then
            if key == 'help' then
               print(usage)
               print_options()
               os.exit(0)
            elseif key == 'dryryn' then dryrun = to_boolean(cmd[1])
            elseif key == 'file' then partition_file = cmd[1]
            elseif key == 'host' then hostname = cmd[1]
            elseif key == 'time' then timezone = cmd[1]
            elseif key == 'lang' then language = cmd[1]
            elseif key == 'pass' then password = cmd[1]
            else
               print(string.format(
                  'unrecognized option "%s".\n%s\nexiting...',
                  key, usage
               ))
               os.exit(1)
            end
         end
      end)
   end
end

function make_schema()
   function make_schema_item(str)
      local items = split_str(str, ' ')
      return {
         disk=items[1],
         part_type=items[2],
         size=items[3],
         fs=items[4],
         name=items[5],
         mount=items[6],
         flags=split_str(items[7], ',')
      }
   end

   io.input(partition_file)
   local str = clean_str(io.read('*all'))
   io.input():close()

   local items = split_str(str, '\n')
   for item in items do
      local schema_item = make_schema_item(item)
      if schema_item['size'] ~= 0 then
         table.insert(schema, schema_item)
      end
   end

   local disk_count = {}
   for ndx=1,# schema do
      local item = schema[ndx]

      if disk_count[item['disk']]
      then disk_count[item['disk']] = disk_count[item['disk']] + 1
      else table.insert(disk_count, item['disk'], 1)
      end

      schema[ndx]['part_num'] = disk_count[item['disk']]
   end
end
function create_partition_tables()
   local initialized_labels = {}

   for item in schema do
      if not disks[item['disk']] then
         print(string.format('disk %s not found. exiting...', item['disk']))
         os.exit(1)
      elseif not initialized_tables[item['disk']] then
         local label_cmd = string.format(
            '%s %s mklabel gpt',
            parted_cmd, item['disk']
         )
         local label_func = function() return os.execute(label_cmd) end
         if check_dryrun(local_cmd, local_func, 0) == 0 then
            initialized_tables[item['disk']] = true
         else
            print(string.format(
               'could not make gpt label for disk %s. exiting...',
               item['disk']
            ))
            os.exit(1)
         end
      end
   end
end
function create_partitions()
   function get_error_message(cmd_str, item)
      string.format(
         'could not %s partition (%s %d %s %s) on disk %s',
         item['part_type'], item['size'], item['fs'],
         item['name'], item['disk']
      )
   end

   local part_start = 0
   local part_stop

   for item in schema do
      part_stop = part_start + item['size']

      -- make partition
      local partition_cmd = string.format('%s mkpart %s %d %d',
       parted_cmd, item['part_type'], part_start, part_stop)
      local partition_func = function() return os.execute(partition_cmd) end
      if check_dryrun(partition_cmd, partition_func, 0) ~= 0 then
         print(get_error_message('make', item))
         os.exit(1)
      end

      part_start = part_stop + item['size']

      -- name partition
      local name_cmd = string.format('%s name %d %s',
       parted_cmd, item['part_num'], item['name'])
      local name_func = function() return os.execute(name_cmd) end
      if check_dryrun(name_cmd, name_func, 0) ~= 0 then
         print(get_error_message('name', item))
         os.exit(1)
      end

      -- set flags
      for flag in item['flags'] do
         local flag_cmd = string.format('%s set %d %s on',
          parted_cmd, item['part_num'], flag)
         local flag_func = function() return os.execute(flag_cmd) end
         if check_dryrun(flag_cmd, flag_func, 0) ~= 0 then
            print(get_error_message(
               string.format('set flag "%s"', flag), item)
            )
            os.exit(1)
         end
      end

      -- format partitions
      local format_cmd
      if item['fs'] == 'swap' then
         format_cmd = string.format(
            'mkswap %s%d',
            item['disk'], item['part_num']
         )
      elseif item['fs'] ~= 'grub' then
         format_cmd = string.format(
            'mkfs.%s %s%d',
            item['fs'], item['disk'], item['part_num']
         )
      end
      local format_func = function() return os.execute(format_cmd) end
      if format_cmd and check_dryrun(format_cmd, format_func, 0) ~= 0 then
         print(get_error_message('format', item))
         os.exit(1)
      end
   end
end
function mount_filesystems()
   table.sort(schema, function(a, b) return a['mount'] < b['mount'] end)
   for item in schema do
      if item['mount'] ~= 'swap' and item['mount'] ~= 'grub' then
         local dir = string.format('/mnt%s', item['mount'])

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
            item['disk'], item['part_num'], dir
         )
         local mount_func = function() return os.execute(mount_cmd) end
         if check_dryrun(mount_cmd, mount_func, 0) ~= 0 then
            print(string.format(
               'could not mount %s%d at "%s". exiting...',
               item['disk'], item['part_num'], dir
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
   if check_dir(base_cmd, base_func, 0) ~= 0 then
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
   if chroot(locale_cmd) ~= 0 then
      print('could not set locale. exiting...')
      os.exit(1)
   end

   -- create initial ramdisk
   if chroot('mkinitcpio -p linux') ~= 0 then
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
   if chroot(bootloader_cmd) ~= 0 then
      print('could not install bootloader. exiting...')
      os.exit(1)
   end

   -- set root password
   local passwd_cmd = string.format('echo \'root:%s\' | chpasswd', password)
   if chroot(passwd_cmd) ~= 0 then
      print('could not set root password. exiting...')
      os.exit(1)
   end
end
function clean()
   table.sort(schema, function(a, b) return a['mount'] > b['mount'] end)
   for item in schema do
      local umount_cmd = string.format('umount %s', item['mount'])
      local umount_func = function() return os.execute(umount_cmd) end
      if check_dryrun(umount_cmd, umount_func, 0) ~= 0 then
         print(string.format(
            'could not dismount filesystem %s%d at "%s". exiting...',
            item['disk'], item['part_num'], item['mount']
         ))
         os.exit(1)
      end
   end
end

cmd_line()
partition()
install()
clean()
print('installation completed without errors.')
