if [ "$(uname -s)" == "Darwin" ]; then
   function link() {
      local source_file="$1"
      local link_file="$2"

      rm -rf "$link_file"
      ln -sf "$source_file" "$link_file"
   }

   function user_name() {
      id -un
   }

   function change_shell() {
      local shell="$1"
      local user="$2"

      sudo chsh -s "$shell" "$user"
   }

   function make_directory() {
      mkdir -p $@
   }
else
   function link() {
      local source_file="$1"
      local link_file="$2"

      rm --recursive --force "$link_file"
      ln --symbolic --force "$source_file" "$link_file"
   }

   function user_name() {
      id --user --name
   }

   function change_shell() {
      local shell="$1"
      local user="$2"

      sudo chsh --shell "$shell" "$user"
   }

   function make_directory() {
      mkdir --parents $@
   }
fi

export -f link
export -f user_name
export -f change_shell
export -f make_directory
