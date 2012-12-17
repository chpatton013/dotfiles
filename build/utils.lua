function split_str(str, delim)
   str = str or ''
   delim = string.format('[^%s]+', (delim or '%s'))
   local tbl = {}
   for line in string.gmatch(str, delim) do table.insert(tbl, line) end
   return tbl
end
function clean_str(str)
   str = str or ''
   return str:gsub('((^%s)|(%s$))+', ''):gsub('[\n\r]+', '\n')
end
function make_list(fstr)
   function remove_comments(str)
      if str
      then return string.gsub(str, '#[^$]*$', '')
      else return ''
      end
   end

   local str = clean_str(fstr:read('*all'))

   fstr:close()

   local list = {}
   for _,line in pairs(split_str(str, '\n')) do
      line = remove_comments(line)
      if line and line ~= '' then
         table.insert(list, line)
      end
   end
   return list
end
function make_set(tbl)
   tbl = tbl or {}
   local set = {}
   for _,row in pairs(tbl) do set[row] = true end
   return set
end

function io.log(str, force)
   str = str or ''

   if not quiet or force
   then log_fstr:write(str .. '\n')
   end
end
function io.log_err(str)
   str = str or ''

   io.stderr:write(str .. '\n')

   if log_fstr ~= io.stdout and log_fstr ~= io.stderr
   then io.log(str, true)
   end
end

function os.dryrun(cmd, success)
   cmd = cmd or ''
   io.log(cmd)

   if dryrun
   then return success
   else return os.execute(cmd)
   end
end
function os.capture(cmd, raw)
   local f = io.popen(cmd, 'r')
   if not f then
      io.stderr:write(string.format(
         'could not execute command \'%s\'. exiting...',
         cmd
      ))
      os.exit(1)
   end

   local s = f:read('*a')
   f:close()

   if raw
   then return s or ''
   else return clean_str(s)
   end
end
function os.chroot(cmd, success)
   cmd = cmd or ''

   local chroot_cmd = string.format(
      'arch-chroot /mnt %s',
      cmd:gsub('"', '\\"')
   )
   return os.dryrun(chroot_cmd, success)
end
