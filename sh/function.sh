function random_string() {
   local length="$1"
   base64 /dev/urandom | tr -d '/+' | fold -w "$length" | head -n 1
}

# `ls` displays trailing identifiers ('/' or '*'), color, and non-printables.
if [ "$(uname -s)" = "Darwin" ]; then
   function ls() {
      /bin/ls -Fb $@
   }
else
   function ls() {
      /bin/ls --classify --escape $@
   }
fi

function cd() {
   builtin cd $@ && ls
}

function fuck() {
   sudo $(fc -ln -1)
}

function tmux_start_session() {
   local name="$1"
   if [ -z "$name" ]; then
      tmux
   else
      if tmux has-session -t "$name"; then
         tmux attach -t "$name"
      else
         tmux new -s "$name"
      fi
   fi
}

function ifind() {
   find . -iname "*$@*"
}

function vpn() {
   sudo openvpn ~/.vpn/client.ovpn
}

function docker_push() {
   image_name="$1"
   tag="$2"

   user_name="chpatton013"
   user_email="chpatton013@gmail.com"
   identifier="$user_name/$image_name"

   docker login --username="$user_name" --email="$user_email"

   image_id="$(docker images --quiet "$image_name")"

   docker tag "$image_id" "$identifier:$tag"
   docker push "$identifier"
}
