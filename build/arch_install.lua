require 'utils'

-- global variables
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
   log = {
      short='-l', full='--log',
      description='write status to log file instead of printing.'
   },
   file = {
      short='-f', full='--file',
      description='set the filename of the partition schema.'
   },
   pass = {
      short='-p', full='--password',
      description='set the password of the root user.'
   }
}
disks = make_set(split_str(
   os.capture(string.format(
      '%s | %s | %s | %s',
      'fdisk -l', 'grep -i \'disk\'',
      'awk -F \':\' \'{ print $1 }\'', 'awk \'{ print $2 }\''
   )),
   "\n"
))
schema = {}
parted_cmd = 'parted --align optimal --script --'
dryrun = false
quiet = false
log_fstr = io.stdout
log_file = nil
partition_file = './files/schema'
password = 'feedface'

-- function definitions
function cmd_line()
   function get_options()
      local opt_str = 'options:\n'
      for _,op in pairs(options) do
         opt_str = opt_str .. (string.format(
            '   %s | %-10s: %s\n',
            op['short'], op['full'], op['description']
         ))
      end
      return opt_str
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
               io.stdout:write(usage .. '\n')
               io.stdout:write(get_options())
               os.exit(0)
            elseif key == 'dryrun' then
               if cmd[2] == nil
               then dryrun = true
               else dryrun = not not cmd[1]
               end
            elseif key == 'quiet' then
               if cmd[2] == nil
               then quiet = true
               else quiet = not not cmd[1]
               end
            elseif key == 'log' then log_file = cmd[2]
            elseif key == 'file' then partition_file = cmd[2]
            elseif key == 'pass' then password = cmd[2]
            else
               io.stderr:write(string.format(
                  'unrecognized option "%s".\n%s\nexiting...\n',
                  key, usage
               ))
               os.exit(1)
            end
         end
      end
   end

   if log_file then
      if not quiet then
         io.stdout:write(string.format(
            'logging installation status in file \'%s\'\n',
            log_file
         ))
      end

      log_fstr = io.open(log_file, 'w')

      if not log_fstr then
         io.stderr:write(string.format(
            'could not open file %q for writing. exiting...\n',
            log_file
         ))
         os.exit(1)
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

   local fstr = io.open(partition_file, 'r')
   if not fstr then
      io.stderr:write(string.format(
         'could not open file %q for reading. exiting...\n',
         partition_file
      ))
      os.exit(1)
   end

   local str = clean_str(fstr:read('*all'))

   fstr:close()

   for _,row in pairs(split_str(str, '\n')) do
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
         io.log_err(string.format(
            'disk %s not found. exiting...',
            row['disk']
         ))
         os.exit(1)
      elseif not initialized_labels[row['disk']] then
         local label_cmd = string.format(
            '%s %s mklabel gpt',
            parted_cmd, row['disk']
         )
         if os.dryrun(label_cmd, 0) == 0 then
            initialized_labels[row['disk']] = true
         else
            io.log_err(string.format(
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
         'could not %s partition (%s %s %s %s) on disk %s',
         cmd_str, row['part_type'], row['size'],
         row['fs'], row['name'], row['disk']
      )
   end

   local disk_partitions = {}

   for _,row in pairs(schema) do
      -- determine partitions boundaries
      if disk_partitions[row['disk']] == nil
      then disk_partitions[row['disk']] = 0
      end

      local part_start = disk_partitions[row['disk']]
      local part_stop

      if tonumber(row['size']) < 0
      then part_stop = '-0'
      else part_stop = part_start + row['size']
      end

      -- make partition
      local partition_cmd = string.format('%s %s mkpart %s %s %s',
       parted_cmd, row['disk'], row['part_type'], part_start, part_stop)
      if os.dryrun(partition_cmd, 0) ~= 0 then
         io.log_err(get_error_message('make', row))
         os.exit(1)
      end

      disk_partitions[row['disk']] = part_stop

      -- name partition
      local name_cmd = string.format('%s %s name %d %s',
       parted_cmd, row['disk'], row['part_num'], row['name'])
      if os.dryrun(name_cmd, 0) ~= 0 then
         io.log_err(get_error_message('name', row))
         os.exit(1)
      end

      -- set flags
      for _,flag in pairs(row['flags']) do
         local flag_cmd = string.format(
            '%s %s set %d %s on',
            parted_cmd, row['disk'], row['part_num'], flag
         )
         if os.dryrun(flag_cmd, 0) ~= 0 then
            io.log_err(get_error_message(
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
      if format_cmd and (os.dryrun(format_cmd, 0) ~= 0) then
         io.log_err(get_error_message('format', row))
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
         if os.dryrun(mkdir_cmd, 0) ~= 0 then
            io.log_err(string.format(
               'could not make directory "%s". exiting...',
               dir
            ))
            os.exit(1)
         end

         local mount_cmd = string.format(
            'mount %s%d %s',
            row['disk'], row['part_num'], dir
         )
         if os.dryrun(mount_cmd, 0) ~= 0 then
            io.log_err(string.format(
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
   if os.dryrun(base_cmd, 0) ~= 0 then
      io.log_err('could not install base system. exiting...')
      os.exit(1)
   end

   -- generate fstab
   local fstab_cmd = 'genfstab -p /mnt >> /mnt/etc/fstab'
   if os.dryrun(fstab_cmd, 0) ~= 0 then
      io.log_err('could not generate fstab. exiting...')
      os.exit(1)
   end

   -- create initial ramdisk
   local ramdisk_cmd = 'mkinitcpio -p linux'
   if os.chroot(ramdisk_cmd, 0) ~= 0 then
      io.log_err('could not create initial ramdisk. exiting...')
      os.exit(1)
   end

   -- install bootloader
   local boot_disk
   for _,row in pairs(schema) do
      if row['name'] == 'grub' then
         boot_disk = row['disk']
      end
   end
   if boot_disk == nil then
      io.log_err('could not identify boot disk. exiting...')
      os.exit(1)
   end
   local bootloader_cmd = {
      'modprobe dm-mod',
      string.format('grub-install %s', boot_disk),
      'mkdir -p /mnt/boot/grub/locale',
      string.format('cp %s %s',
         '/mnt/usr/share/locale/en@quot/LC_MESSAGES/grub.mo',
         '/mnt/boot/grub/locale/en.mo'
      ),
      'grub-mkconfig -o /boot/grub/grub.cfg'
   }
   if not (
      (os.chroot(bootloader_cmd[1], 0) == 0) and
      (os.chroot(bootloader_cmd[2], 0) == 0) and
      (os.dryrun(bootloader_cmd[3], 0) == 0) and
      (os.dryrun(bootloader_cmd[4], 0) == 0) and
      (os.chroot(bootloader_cmd[5], 0) == 0)
   ) then
      io.log_err('could not install bootloader. exiting...')
      os.exit(1)
   end

   -- set root password
   local passwd_cmd = string.format(
      'echo root:%s | chpasswd --root /mnt',
      password
   )
   if os.dryrun(passwd_cmd, 0) ~= 0 then
      io.log_err('could not set root password. exiting...')
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
         if os.dryrun(umount_cmd, 0) ~= 0 then
            io.log_err(string.format(
               'could not dismount filesystem %s%d at "%s". exiting...',
               row['disk'], row['part_num'], row['mount']
            ))
            os.exit(1)
         end
      end
   end
end

-- installation commands
cmd_line()
partition()
install()
clean()
io.stdout:write('installation completed without errors.')
os.exit(0)
