-- helper functions
function os.capture(cmd, raw)
   local f = assert(io.popen(cmd, 'r'))
   local s = assert(f:read('*a'))
   f:close()

   if raw then
      return s
   else
      return s:gsub('((^%s)|(%s$))+', ''):gsub('[\n\r]+', '\n')
   end
end

function chroot(cmd)
   if cmd == nil then
      cmd = ''
   end
   return os.execute(string.format('arch-chroot /mnt "%s; exit"', cmd))
end

-- global variables
low = 0
normal = 1
high = 2

verbose = normal
interactive = normal

architecture = os.capture('lscpu | grep -i \'architecture\' ' ..
 '| awk \'{ print $2 }\'')
dflt_hostname = string.format('arch-%s', architecture)

ls_disk_names = ls_disks .. ' | awk -F ":" "{ print $1 }" | awk "{ print $2 }"'

function cmd_line_options(options)
   for ndx=1,# options do
      if options[ndx] == 'h' then -- display help message and exit
         local help = {
            usage,
            '',
            'options:',
            '   h - help - display this help message and exit',
            '   q - quiet - do not display output during execution unless necessary',
            '   v - verbose - display additional output where possible',
            '   s - script - run as an automated build script',
            '   a - automatic - try to make intelligent decisions about system configuration',
            '   i - interactive - prompt user for input during system configuration',
            '',
            'With all mutually exclusive options, the last specified options takes precedence.',
            '',
            'commands: none implemented'
         }

         for line in help do
            print(line)
         end

         os.exit(0)
      elseif options[ndx] == 'q' then -- run in quiet mode
         verbose = low
      elseif options[ndx] == 'v' then -- run in verbose mode
         verbose = high
      elseif options[ndx] == 's' then -- run in script mode
         interactive = low
      elseif options[ndx] == 'a' then -- run in automatic mode
         interactive = normal
      elseif options[ndx] == 'i' then -- run in interactive mode
         interactive = high
      elseif options[ndx] == '-' and ndx == 1 then -- do nothing
      else -- check for invalid options
         print(usage)
         os.exit(1)
      end
   end
end

function cmd_line_cmds(cmd)
   if cmd:find('--net=')[0] == 1 then
      local equal = cmd:find('=')[0]
      local comma = cmd:find(',')[0]
      if comma ~= nil then
         essid = cmd:sub(equal, comma-1)
         net_pw = cmd:sub(comma+1)
      else
         essid = cmd:sub(equal)
      end
   else
      print('\'' .. cmd .. '\' is not a valid command')
      os.exit(1)
   end
end

function cmd_line()
   usage = string.format('usage %s [ options ] [ commands ]', arg[0])

   local cmd_ndx_start = 1
   local first_char = arg[1][1]
   local second_char = arg[1][2]
   if first_char ~= '-' or first_char == '-' and second_char ~= '-' then -- options specified
      cmd_line_options(arg[1])
      cmd_ndx_start = 2
   end

   for ndx=cmd_ndx_start,# arg do
      cmd_line_cmds(arg[ndx])
   end
end

function get_disk()
   local disk

   if interactive ~= low then
      repeat
         local matched = false

         print ('select disk:')
         os.execute(ls_disks)
         disk = io.read()

         disk_names = os.capture(ls_disk_names)
         for name in disk_names:gsub('((^%s)|(%s$))+', ''):gsub('[\n\r]+',
          '\n'):gmatch('[\n]+') do
            if disk == name then
               matched = true
               break
            end
         end
      until matched
   else
      disk = os.capture(ls_disk_names .. ' | head -n 1')
   end

   return disk
end

function get_schemas()
   return {
      pico = {
         size = 8,
         summary = string.format("%s, %s, %s, %s (approximately %dGB)",
            'grub: 2MB', 'boot: 100MB', 'swap: 256MB', 'root: remaining space',
            size
         ),
         table = {
            { name = 'grub', part_type = 'primary', size = 2,
              flags = {'bios_grub'} },
            { name = 'boot', part_type = 'primary', size = 100,
              flags = {'boot'}, fs = 'ext4', mnt_pt = '/boot' },
            { name = 'swap', part_type = 'logical', size = 256 },
            { name = 'root', part_type = 'logical', fs = 'ext4', mnt_pt = '/' }
         }
      },
      nano = {
         size = 10,
         summary = string.format("%s, %s, %s, %s (approximately %dGB)",
            'grub: 2MB', 'boot: 128MB', 'swap: 512MB', 'root: remaining space',
            size
         ),
         table = {
            { name = 'grub', part_type = 'primary', size = 2,
              flags = {'bios_grub'} },
            { name = 'boot', part_type = 'primary', size = 128,
              flags = {'boot'}, fs = 'ext4', mnt_pt = '/boot' },
            { name = 'swap', part_type = 'logical', size = 512 },
            { name = 'root', part_type = 'logical', fs = 'ext4', mnt_pt = '/' }
         }
      },
      micro = {
         size = 20,
         summary = string.format("%s, %s, %s, %s, %s (approximately %dGB)",
            'grub: 2MB', 'boot: 128MB', 'swap: 1GB', 'root: 8GB',
            'home: remaining space', size
         ),
         table = {
            { name = 'grub', part_type = 'primary', size = 2, flags = {'bios_grub'} },
            { name = 'boot', part_type = 'primary', size = 128,
              flags = {'boot'}, fs = 'ext4', mnt_pt = '/boot' },
            { name = 'swap', part_type = 'logical', size = 1024 },
            { name = 'root', part_type = 'logical', size = 8192, fs = 'ext4',
              mnt_pt = '/' },
            { name = 'home', part_type = 'logical', fs = 'ext4',
              mnt_pt = '/home' }
         }
      },
      milli = {
         size = 30,
         summary = string.format("%s, %s, %s, %s, %s (approximately %dGB)",
            'grub: 2MB', 'boot: 128MB', 'swap: 2GB', 'root: 12GB',
            'home: remaining space', size
         ),
         table = {
            { name = 'grub', part_type = 'primary', size = 2,
              flags = {'bios_grub'} },
            { name = 'boot', part_type = 'primary', size = 128,
              flags = {'boot'}, fs = 'ext4', mnt_pt = '/boot' },
            { name = 'swap', part_type = 'logical', size = 2048 },
            { name = 'root', part_type = 'logical', size = 12288, fs = 'ext4',
              mnt_pt = '/' },
            { name = 'home', part_type = 'logical', fs = 'ext4',
              mnt_pt = '/home' }
         }
      },
      standard = {
         size = 50,
         summary = string.format("%s, %s, %s, %s, %s, %s (approximately %dGB)",
            'grub: 2MB', 'boot: 128MB', 'swap: 4GB', 'root: 12GB', 'var: 4GB',
            'home: remaining space', size
         ),
         table = {
            { name = 'grub', part_type = 'primary', size = 2,
              flags = {'bios_grub'} },
            { name = 'boot', part_type = 'primary', size = 128,
              flags = {'boot'}, fs = 'ext4', mnt_pt = '/boot' },
            { name = 'swap', part_type = 'logical', size = 4096 },
            { name = 'root', part_type = 'logical', size = 12288, fs = 'ext4',
              mnt_pt = '/' },
            { name = 'var', part_type = 'logical', size = 4096, fs = 'ext4',
              mnt_pt = '/var' },
            { name = 'home', part_type = 'logical', fs = 'ext4',
              mnt_pt = '/home' }
         }
      },
      kilo = {
         size = 75,
         summary = string.format("%s, %s, %s, %s, %s, %s (approximately %dGB)",
            'grub: 2MB', 'boot: 128MB', 'swap: 8GB', 'root: 16GB', 'var: 8GB',
            'home: remaining space', size
         ),
         table = {
            { name = 'grub', part_type = 'primary', size = 2,
              flags = {'bios_grub'} },
            { name = 'boot', part_type = 'primary', size = 128,
              flags = {'boot'}, fs = 'ext4', mnt_pt = '/boot' },
            { name = 'swap', part_type = 'logical', size = 8196 },
            { name = 'root', part_type = 'logical', size = 16384, fs = 'ext4',
              mnt_pt = '/' },
            { name = 'var', part_type = 'logical', size = 8196, fs = 'ext4',
              mnt_pt = '/var' },
            { name = 'home', part_type = 'logical', fs = 'ext4',
              mnt_pt = '/home' }
         }
      },
      mega = {
         size = 100,
         summary = string.format("%s, %s, %s, %s, %s, %s, %s (approximately %dGB)",
            'grub: 2MB', 'boot: 128MB', 'swap: 12GB', 'root: 16GB', 'var: 8GB',
            'tmp: 8GB', 'home: remaining space', size
         ),
         table = {
            { name = 'grub', part_type = 'primary', size = 2,
              flags = {'bios_grub'} },
            { name = 'boot', part_type = 'primary', size = 128,
              flags = {'boot'}, fs = 'ext4', mnt_pt = '/boot' },
            { name = 'swap', part_type = 'logical', size = 12288 },
            { name = 'root', part_type = 'logical', size = 16384, fs = 'ext4',
              mnt_pt = '/' },
            { name = 'var', part_type = 'logical', size = 8196, fs = 'ext4',
              mnt_pt = '/var' },
            { name = 'tmp', part_type = 'logical', size = 8196, fs = 'ext4',
              mnt_pt = '/tmp' },
            { name = 'home', part_type = 'logical', fs = 'ext4',
              mnt_pt = '/home' }
         }
      },
      giga = {
         size = 150,
         summary = string.format("%s, %s, %s, %s, %s, %s, %s (approximately %dGB)",
            'grub: 2MB', 'boot: 128MB', 'swap: 16GB', 'root: 24GB', 'var: 12GB',
            'tmp: 12GB', 'home: remaining space', size
         ),
         table = {
            { name = 'grub', part_type = 'primary', size = 2,
              flags = {'bios_grub'} },
            { name = 'boot', part_type = 'primary', size = 128,
              flags = {'boot'}, fs = 'ext4', mnt_pt = '/boot' },
            { name = 'swap', part_type = 'logical', size = 16384 },
            { name = 'root', part_type = 'logical', size = 24576, fs = 'ext4',
              mnt_pt = '/' },
            { name = 'var', part_type = 'logical', size = 12288, fs = 'ext4',
              mnt_pt = '/var' },
            { name = 'tmp', part_type = 'logical', size = 12288, fs = 'ext4',
              mnt_pt = '/tmp' },
            { name = 'home', part_type = 'logical', fs = 'ext4',
              mnt_pt = '/home' }
         }
      },
      tera = {
         size = 200,
         summary = string.format("%s, %s, %s, %s, %s, %s, %s (approximately %dGB)",
            'grub: 2MB', 'boot: 128MB', 'swap: 16GB', 'root: 24GB', 'var: 16GB',
            'tmp: 16GB', 'home: remaining space', size
         ),
         table = {
            { name = 'grub', part_type = 'primary', size = 2,
              flags = {'bios_grub'} },
            { name = 'boot', part_type = 'primary', size = 128,
              flags = {'boot'}, fs = 'ext4', mnt_pt = '/boot' },
            { name = 'swap', part_type = 'logical', size = 16384 },
            { name = 'root', part_type = 'logical', size = 24576, fs = 'ext4',
              mnt_pt = '/' },
            { name = 'var', part_type = 'logical', size = 16384, fs = 'ext4',
              mnt_pt = '/var' },
            { name = 'tmp', part_type = 'logical', size = 16384, fs = 'ext4',
              mnt_pt = '/tmp' },
            { name = 'home', part_type = 'logical', fs = 'ext4',
              mnt_pt = '/home' }
         }
      }
   }
end

function get_schema_table()
   local disk_size = tonumber(os.capture(string.format('%s | grep "%s"' ..
    ' | awk -F "," "{ print $2}" | awk "{ print $1 }"'), ls_disks, disk)) /
    math.pow(2, 30)

   if interactive == high then
   else
      local schemas = get_schemas()
      local option

      if interactive == normal then
         if disk_size < schemas['pico']['size'] then
            option = 'pico'
         else
            print('select desired schema:')
            repeat
               for schema in schemas do -- print valid schemas
                  if disk_size > schema['size'] then
                     print(schema['summary'])
                  end
               end
               option = io.read()
            until schemas[option] ~= nil
         end
      else
         for schema in schemas do -- select largest schema
            if disk_size > schema['size'] then
               option = schema
            end
         end
         if option == nil then
            option = 'pico'
         end
      end

      schema_table = schemas[option]['table']
   end
end

function create_partitions(disk, schema_table)
   if verbose == low then
      local parted_output = '--script'
   else
      local parted_output = ''
   end

   local parted_cmd = string.format('parted %s %s', parted_output, disk)

   local start = 1
   local stop

   -- create gpt partition table
   if os.execute(string.format('%s mklabel gpt', parted_cmd)) ~= 0 then
      return false
   end

   for ndx=1,# schema_table do
      -- determine endpoint of partition
      if schema_table[ndx]['size'] == nil then
         stop = -1
      else
         stop = start + schema_table[ndx]['size']
      end

      -- create partition
      local mkpart_cmd = string.format('%s mkpart %s %d %d', parted_cmd,
       schema_table[ndx]['part_type'], start, stop)
      if os.execute(mkpart_cmd) ~= 0 then -- most likely no room for partition
         return false
      end

      start = stop

      -- name partition if name is present
      if schema_table[ndx]['name'] ~= nil then
         os.execute(string.format('%s name %d %s', parted_cmd, ndx,
          schema_table[ndx]['name']))
      end

      -- turn on flags for partition
      if schema_table[ndx]['flags'] ~= nil then
         for flag in schema_table[ndx]['flags'] do
            os.execute(string.format('%s set %d %s on', parted_cmd, ndx, flag))
         end
      end
   end

   return true
end

function format_partitions(disk, schema_table)
   if verbose == low then
      local fmt_output = ''
   else
      local fmt_output = '-q'
   end

   for ndx=1,# schema_table do
      if schema_table[ndx]['name'] == 'swap' then
         if os.execute(string.format('mkswap $s$d', disk, ndx)) ~= 0 then
            return false
         end
      elseif schema_table[ndx]['fs'] ~= nil then
         local fmt_cmd = string.format('mkfs.%s %s %s%d',
          schema_table[ndx]['fs'], fmt_output, disk, ndx)

          if os.execute(fmt_cmd) ~= 0 then
             return false
          end
      end
   end

   return true
end

function mount_partitions(disk, schema_table)
   return true
end

function partition()
   if verbose ~= low then
      print('creating filesystems')
   end

   repeat
      local retry = false
      local disk = get_disk()
      local schema_table = get_schema_table()

      if create_partitions(disk, schema_table) ~= true then
         repeat
            print('partition creation failed.')
            io.write('care to try again? [y/n]: ')
            io.flush()
            option = io.read()
         until option == 'y' or option == 'n'

         if option == 'y' then
            retry = true
         else
            print('exiting...')
            os.exit(1)
         end
      end

      if format_partitions(disk, schema_table) ~= true then
         repeat
            print('partition formatting failed.')
            io.write('care to try again? [y/n]: ')
            io.flush()
            option = io.read()
         until option == 'y' or option == 'n'

         if option == 'y' then
            retry = true
         else
            print('exiting...')
            os.exit(1)
         end
      end

      if mount_partitions(disk, schema_table) ~= true then
         repeat
            print('partition mounting failed.')
            io.write('care to try again? [y/n]: ')
            io.flush()
            option = io.read()
         until option == 'y' or option == 'n'

         if option == 'y' then
            retry = true
         else
            print('exiting...')
            os.exit(1)
         end
      end
   until retry == false
end

function network()
   if verbose ~= low then
      print('setting up network')
   end

   local net_devices = os.capture('ifconfig | grep -E "(eth|wlan)[0-9]+" ' ..
    '| awk -F \':\' \'{ print $1 }\'')

   if net_devices == nil or net_devices.len == 0 then
      print('no network devices detected. installation cannot continue.')
      print('exiting...')
      os.exit(1)
   end

   for device in net_devices:gsub('((^%s)|(%s$))+', ''):gsub('[\n\r]+',
    '\n'):gmatch('[\n]+') do
      os.execute('ifconfig ' .. device .. ' up')
   end

   local ping = os.execute('ping -c 3 8.8.8.8')
   if ping == 0 then
      if verbose ~= low then
         print('wired network established. continuing with installation.')
      end
   else
      print('no current connection detected. wireless not currently supported.')
      print('exiting...')
      os.exit(1)
      if verbose ~= low then
         print('no current connection detected. falling back to wireless...')
      end
      -- iwconfig wlan0 essid NETWORK_ID key WIRELESS_KEY
      if interactive == high then
      else
      end
   end

   dhclient = 'dhclient '
   if verbose == low then
      dhclient = dhclient .. '-q '
   end
   if verbose == high then
      print('running dhclient...')
      dhclient = dhclient .. '-v '
   end
   for device in net_devices.gmatch('\n') do
      os.execute(dhclient .. device);
   end
end

function settings()
   local hostname = dflt_hostname
   if interactive ~= low then
      io.write('enter hostname: ')
      io.flush()
      hostname = io.read()
   else
      if verbose == high then
         print('setting hostname...')
      end
   end
   os.execute(string.format('echo %s /mnt/etc/hostname', hostname))

   if verbose == high then
      print('setting timezone...')
   end
   os.execute('ln -sf /mnt/usr/share/zoneinfo/America/Los_Angeles ' ..
    '/mnt/etc/localtime')

   if verbose == high then
      print('generating locale...')
   end
   local lang = 'en_US.UTF-8'
   os.execute('sed -i \'s/^#\'%s\'/\'%s\'/g\' /mnt/etc/locale.gen', lang, lang)
   chroot('locale-gen')
end

function ramdisk()
   if verbose == high then
      print('configuring initial ramdisk...')
   end

   local mkinitcpio = 'mkinitcpio '
   if verbose == high then
      mkinitcpio = mkinitcpio .. '-v '
   end
   mkinitcpio = mkinitcpio .. '-p linux'

   if interactive ~= low then
      local ramdisk_config
      repeat
         repeat
            io.write('(s)pecify a path to, manually (e)dit, or use the ' ..
             '(d)efault ramdisk configuration [s,e,d]: ')
            io.flush()
            local option = io.read()
         until option == 's' or option == 'e' or option == 'd'

         if option == 's' then
            repeat
               io.write('specify valid path or (q)uit: ')
               io.flush()
               local path = io.read()
               if path ~= 'q' then
                  local f = io.open(path, "r")
               end
            until f ~= nil or path == 'q'

            if f ~= nil then
               io.close(f)
               ramdisk_config = 'done'
            end
         elseif option == 'e' then
            if os.execute('vi /mnt/etc/mkinitcpio.conf') then
               ramdisk_config = 'done'
            end
         end
      until ramdisk_config == 'done'
   end

   chroot(mkinitcpio)
end

function install()
   if verbose ~= low then
      print('installing system')
   end

   if verbose == high then
      print('installing packages...')
   end
   os.execute('pacstrap /mnt base base-devel grub-bios')

   if verbose == high then
      print('generating fstab...')
   end
   os.execute('genfstab -p /mnt >> /mnt/etc/fstab')

   settings()
   ramdisk()

   if verbose == high then
      print('installing bootloader...')
   end
   chroot('modprobe dm-mod')
   chroot('grub-install /dev/sda')
   os.execute('cp /mnt/usr/share/locale/en@quot/LC_MESSAGES/grub.mo ' ..
    '/mnt/boot/grub/locale/en.mo')
   chroot('grub-mkconfig -o /boot/grub/grub.cfg')

   if verbose == high then
      print('setting password...')
   end
   if interactive == low then
      chroot('echo \'root:feedface\' | chpasswd')
   else
      chroot('while [ `passwd` != 0 ] do done')
   end
end

function clean()
   if verbose ~= low then
      print('cleaning up')
   end
   if verbose == high then
      print('dismounting filesystems...')
   end
end

cmd_line()
partition()
network()
install()
clean()
