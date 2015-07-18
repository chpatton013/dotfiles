export ZOOX_WORKSPACE=~/zoox_ros_ws
export VLR_ROOT=~/projects/vlr

source /opt/ros/indigo/setup.zsh
source "$ZOOX_WORKSPACE/devel/setup.zsh"

function zmake() {
   (builtin cd "$ZOOX_WORKSPACE"; catkin_make && catkin_make tests)
}

function ztest() {
   if [ ! "$1" ] || [ ! "$2" ] || [ "$#" -gt 3 ]; then
      echo "Usage: ztest <package> <launch> [<clock rate>]"
      return 1
   fi

   local package="$1"
   local launch="$2"
   local clock="$3"
   if [ ! "$clock" ]; then
      clock="10"
   fi

   ztest_base "$package" "$launch" "$clock" 'true' 'false' ''
}

function zttest() {
   if [ ! "$1" ] || [ ! "$2" ] || [ "$#" -gt 3 ]; then
      echo "Usage: zttest <package> <launch> [<clock rate>]"
      return 1
   fi

   local package="$1"
   local launch="$2"
   local clock="$3"
   if [ ! "$clock" ]; then
      clock="10"
   fi

   ztest_base "$package" "$launch" "$clock" 'true' 'false' '--text'
}

function zftest() {
   if [ ! "$1" ] || [ ! "$2" ] || [ "$#" -gt 2 ]; then
      echo "Usage: zftest <package> <launch>"
      return 1
   fi

   local package="$1"
   local launch="$2"

   ztest_base "$package" "$launch" "10" 'false' 'true' ''
}

function ztest_base() {
   local package="$1"
   local launch="$2"
   local clock="$3"
   local rviz="$4"
   local short_circuit="$5"
   local text="$6"

   rostest $package $launch clock:=$clock rviz:=$rviz \
    short_circuit:=$short_circuit $text
}
