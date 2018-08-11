function random_string() {
  local length
  length="$1"
  readonly length
  base64 /dev/urandom | tr -d '/+' | fold -w "$length" | head -n 1
}

# Show trailing file type identifiers (*, /, etc) and non-printables.
function ls() {
  /bin/ls -Fb "$@"
}

function cd() {
  builtin cd "$@" && ls
}

function tmux_start_session() {
  local name
  name="$1"
  readonly name

  if [ -z "$name" ]; then
    tmux
  elif tmux has-session -t "$name" 2>/dev/null; then
    tmux attach -t "$name"
  else
    tmux new -s "$name"
  fi
}

function ifind() {
  find . -iname "*$@*"
}

function vpn() {
  sudo openvpn ~/.vpn/client.ovpn
}

function docker_push() {
  local image_name tag user_name user_email identifier
  image_name="$1"
  tag="${2:-latest}"
  user_name="chpatton013"
  user_email="chpatton013@gmail.com"
  identifier="$user_name/$image_name"
  readonly image_name tag user_name user_email identifier

  docker login --username="$user_name" --email="$user_email"

  local image_id
  image_id="$(docker images --quiet "$image_name")"
  readonly image_id

  docker tag "$image_id" "$identifier:$tag"
  docker push "$identifier"
}

function _inotifyrun_invoke() {
  echo CWD: $(pwd)
  echo CMD: $@
  "$@"
  echo
}

function inotifyrun() {
  _inotifyrun_invoke "$@"

  while fswatch \
      --event Updated \
      --event Created \
      --event Removed \
      --event MovedFrom \
      --event MovedTo \
      --recursive \
      --timestamp \
      --extended \
      --exclude ".*/\.git/.*|.*/\.mypy_cache/.*|.*/bazel-.*/.*|(.*\.sw.?$)" \
      .; do
    _inotifyrun_invoke "$@"
  done
}
