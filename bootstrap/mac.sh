function docker_setup() {
   local machine_name=default
   local driver=virtualbox

   echo Setting up machine "'$machine_name'"...

   if ! docker-machine ls --quiet | \
         grep --quiet --extended-regexp "^$machine_name\$"; then
      echo Creating...
      docker-machine create --driver "$driver" "$machine_name"
   fi

   if ! docker-machine active 2>/dev/null | \
         grep --quiet --extended-regexp "^$machine_name\$"; then
      echo Activating...
      docker-machine start "$machine_name"
   fi

   eval "$(docker-machine env default)"
}

if which brew &>/dev/null; then
   PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
   MANPATH="$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"
fi
