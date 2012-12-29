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
      description='do not print status during configuration.'
   },
   log = {
      short='-l', full='--log',
      description='write status to log file instead of printing.'
   },
   internet = {
      short='-i', full='--internet',
      description='specify the desired internet device.'
   },
   hostname = {
      short='-s', full='--hostname',
      description='set the hostname of the machine.'
   },
   language = {
      short='-n', full='--language',
      description='set the language for locale generation.'
   },
   keymap = {
      short='-k', full='--keymap',
      description='set the keymap of the machine.'
   },
   timezone = {
      short='-t', full='--timezone',
      description='set the timezone of the machine.'
   },
   package = {
      short='-p', full='--package',
      description='set the filename of the package list.'
   },
   daemons = {
      short='-a', full='--daemons',
      description='set the filename of the daemon list.'
   },
   files = {
      short='-f', full='--files',
      description='set the directory used for configuration files.'
   }
}
dryrun = false
quiet = false
log_fstr = io.stdout
log_file = nil
internet = 'eth0'
hostname = 'archbox'
language = 'en_US.UTF-8'
keymap = 'us'
timezone = 'America/Los_Angeles'
package_file = './files/packages'
daemon_file = './files/daemons'
files_dir = './files/conf'

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
            elseif key == 'internet' then internet = cmd[2]
            elseif key == 'hostname' then hostname = cmd[2]
            elseif key == 'language' then language = cmd[2]
            elseif key == 'keymap' then keymap = cmd[2]
            elseif key == 'timezone' then timezone = cmd[2]
            elseif key == 'package' then package_file = cmd[2]
            elseif key == 'daemon' then daemon_file = cmd[2]
            elseif key == 'files' then files_dir = cmd[2]
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

function configure()
   -- verify connection to internet
   local internet_cmd = string.format('ls /run/dhcpcd-%s.pid', internet)
   local internet_result = os.capture(internet_cmd)
   if (not internet_result) or (string.len(internet_result) == 0) then
      -- connect to internet
      local connect_cmd = string.format('dhcpcd %s', internet)
      if os.dryrun(connect_cmd, 0) ~= 0 then
         io.log_err('could not connect to the internet. exiting...')
         os.exit(1)
      end
   end

   -- set hostname
   local hostname_cmd = string.format('hostnamectl set-hostname %s', hostname)
   os.dryrun(hostname_cmd, 0)

   -- generate locale
   local locale_cmd = {
      string.format(
         'grep -E "^#?%s" /etc/locale.gen',
         language
      ),
      string.format(
         'sed -i \'s/^#%s/%s/g\' /etc/locale.gen',
         language, language
      ),
      'locale-gen',
      string.format('localectl set-locale LANG=%q', language)
   }
   local locale_result = os.capture(locale_cmd[1])
   if ((not locale_result) or (string.len(locale_result) == 0)) then
      io.log_err('could not set locale. exiting...')
      os.exit(1)
   end
   os.dryrun(locale_cmd[2], 0)
   os.dryrun(locale_cmd[3], 0)
   os.dryrun(locale_cmd[4], 0)

   -- set keymap
   local keymap_cmd = string.format('localectl set-keymap %s', keymap)
   os.dryrun(keymap_cmd, 0)

   -- set timezone
   local timezone_cmd = {
      string.format('ls /usr/share/zoneinfo/%s', timezone),
      string.format('timedatectl set-timezone %s', timezone)
   }
   local timezone_result = os.capture(timezone_cmd[1])
   if (not timezone_result) or (string.len(timezone_result) == 0) then
      io.log_err('could not set timezone. exiting...')
      os.exit(1)
   end
   os.dryrun(timezone_cmd[2], 0)

   -- create configuration files
   local files_cmd = string.format('cp -R %s/* /', files_dir)
   os.dryrun(files_cmd, 0)
end

function packages()
   -- update databases and existing packages
   local pacman_cmd = 'pacman --noconfirm -Syu'
   os.dryrun(pacman_cmd, 0)

   -- install new packages
   local package_fstr = io.open(package_file, 'r')
   if not package_fstr then
      io.log_err(string.format(
         'could not open file %q for reading. exiting...\n',
         package_file
      ))
      os.exit(1)
   end
   local package_list = make_list(package_fstr)
   for _,line in pairs(package_list) do
      local package_cmd = string.format(
         'pacman --noconfirm --needed -S %s',
         line
      )
      os.dryrun(package_cmd, 0)
   end
end

function daemons()
   local daemon_fstr = io.open(daemon_file, 'r')
   if not daemon_fstr then
      io.log_err(string.format(
         'could not open file %q for reading. exiting...\n',
         daemon_file
      ))
      os.exit(1)
   end
   local daemon_list = make_list(daemon_fstr)
   for _,line in pairs(daemon_list) do
      local daemon_cmd = string.format('systemctl enable %s', line)
      os.dryrun(daemon_cmd, 0)
   end
end

-- configuration commands
cmd_line()
configure()
packages()
daemons()
io.stdout:write('system configured without errors.\n')
os.exit(0)
