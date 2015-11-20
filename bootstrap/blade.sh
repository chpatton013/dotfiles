export ZOOX_WORKSPACE=~/zoox_ros_ws
export ROS_WORKSPACE="$ZOOX_WORKSPACE"
export VLR_ROOT=~/projects/vlr
export ROS_LOG_DIR=~/.ros/log
export PATH=/usr/local/cuda-7.0/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-7.0/lib64:$LD_LIBRARY_PATH

function zenv() {
   source "$ZOOX_WORKSPACE/devel/setup.zsh"
}

function _zmake_base() {
   local target="$1"
   (builtin cd "$ZOOX_WORKSPACE" && catkin_make $target)
}

function zmake() {
   if [ "$#" -gt 1 ]; then
      echo "Usage: zmake [core|tests|download|all]"
      return 1
   fi

   local target="$1"

   case $target in
      core | tests | download | all | '')
         ;;
      *)
         echo "Usage: zmake [core|tests|download|all]"
         return 1
         ;;
   esac

   case $target in
      core)
         _zmake_base
         ;;
      tests)
         _zmake_base tests
         ;;
      download)
         _zmake_base download_test_data
         ;;
      all | '')
         _zmake_base &&
         _zmake_base tests &&
         _zmake_base download_test_data
         ;;
   esac
}

function ros_log_latest() {
   echo $(ros_log_dir)/rosout.log
}

function ros_log_dir() {
   find $ROS_LOG_DIR/* -type d -printf '%T@ %p\n' |
      sort --reverse --numeric-sort |
      head --lines=1 |
      cut -f2- -d' '
}

function ros_log() {
   local run_id="$1"
   echo "$ROS_LOG_DIR/$run_id/rosout.log"
}

function _ztest_clock() {
   local clock="$1"
   if [ "$clock" ]; then
      echo "clock:=$clock"
   fi
}

function _ztest_launch_roscore() {
   if ! pgrep roscore &> /dev/null; then
      roscore &
   fi

   while ! rosparam get /run_id &> /dev/null; do :; done
}

function _ztest_launch_rviz() {
# TODO: determine correct launch file
# if rviz is open without correct launch file
#    kill rviz
#    launch rviz
# else if rviz is not running at all
#    launch rviz with correct launch file
# wait for rviz to be ready
   rosparam set /use_sim_time true
   roslaunch aw_simulator rcv_rviz.launch &
   sleep 1
}

function ztest() {
   if [ ! "$1" ] || [ ! "$2" ] || [ "$#" -gt 3 ]; then
      echo "Usage: ztest <package> <launch> [<clock rate>]"
      return 1
   fi

   local package="$1"
   local launch="$2"
   local clock="$3"

   _ztest_launch_roscore

   # _ztest_launch_rviz

   rostest "$package" "$launch" $(_ztest_clock $clock) \
    short_circuit:=false rviz:=true debug_arrival:=false
}

function zttest() {
   if [ ! "$1" ] || [ ! "$2" ] || [ "$#" -gt 3 ]; then
      echo "Usage: zttest <package> <launch> [<clock rate>]"
      return 1
   fi

   local package="$1"
   local launch="$2"
   local clock="$3"

   _ztest_launch_roscore

   local run_id=$(rosparam get /run_id)

   # _ztest_launch_rviz

   rostest --local "$package" "$launch" $(_ztest_clock $clock) \
    short_circuit:=false rviz:=true debug_arrival:=true
   less $(ros_log $run_id)
}

function zftest() {
   if [ ! "$1" ] || [ ! "$2" ] || [ "$#" -gt 2 ]; then
      echo "Usage: zftest <package> <launch>"
      return 1
   fi

   local package="$1"
   local launch="$2"

   _ztest_launch_roscore

   rostest --local "$package" "$launch" \
    short_circuit:=true rviz:=false debug_arrival:=false
}
