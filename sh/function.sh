function random_string() {
  local length; length="$1"; readonly length
  base64 /dev/urandom | tr -d '/+' | fold -w "$length" | head -n 1
}

# `ls` displays trailing identifiers ('/' or '*'), color, and non-printables.
if [ "$(uname -s)" = "Darwin" ]; then
  function ls() {
    /bin/ls -Fb "$@"
  }
else
  function ls() {
    /bin/ls --classify --escape "$@"
  }
fi

function cd() {
  builtin cd "$@" && ls
}

function fuck() {
  sudo $(fc -ln -1)
}

function tmux_start_session() {
  local name; name="$1"; readonly name
  if [ -z "$name" ]; then
    tmux
  elif tmux has-session -t "$name" 2>/dev/null; then
    tmux attach -t "$name"
  else
    tmux new -s "$name"
  fi
}

function ifind() {
  find -iname "*$@*"
}

function vpn() {
  sudo openvpn ~/.vpn/client.ovpn
}

function docker_push() {
  local image_name; image_name="$1"; readonly image_name
  local tag; tag="${2:-latest}"; readonly tag

  local user_name; user_name="chpatton013"; readonly user_name
  local user_email; user_email="chpatton013@gmail.com"; readonly user_email
  local identifier; identifier="$user_name/$image_name"; readonly identifier

  docker login --username="$user_name" --email="$user_email"

  local image_id; image_id="$(docker images --quiet "$image_name")"
  readonly image_id

  docker tag "$image_id" "$identifier:$tag"
  docker push "$identifier"
}

if [ "$(uname -s)" = "Darwin" ]; then
  function inotifyrun() {
    echo "Watching $(pwd): $@"

    "$@"
    echo

    while fswatch --recursive \
      --event Updated \
      --event Created \
      --event Removed \
      --event MovedFrom \
      --event MovedTo \
      --timestamp \
      --extended \
      --exclude ".*/\.git/.*|(.*\.sw.?$)" \
      .; do
    "$@"
    echo
  done
}
else
  function inotifyrun() {
    echo "Watching $(pwd): $@"

    "$@"
    echo

    while inotifywait --quiet \
      --recursive \
      --event close_write \
      --event create \
      --event delete \
      --event moved_to \
      --event moved_from \
      --event unmount \
      --timefmt "%H:%M:%S" \
      --format "%T: %e: %w%f" \
      --exclude ".*/\.git/.*|(.*\.sw.?$)" \
      .; do
    "$@"
    echo
  done
}
fi
