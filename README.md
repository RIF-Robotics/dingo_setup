# Dingo Setup

The purpose of this repository is to help setup the ROS workspace required to
run the Nav2 stack on the Dingo. I'm still not sure if this repository should
exist within the ./src directory of a workspace, or if it should exist outside
of it since this repository contains the dingo_ws.repos file, which is required
by the vcs tool to clone the repositories into the workspace. For this reason,
I think this repository should exist outside of the traditional workspace, but
it might not matter at the moment.

## Setup Instructions

1. Create a ROS workspace. I use separate `~/ros1` and `~/ros2` directories and
   then separate workspaces for different projects.

        $ mkdir -p ~/ros2/dingo_ws/src

2. Clone this repository into the workspace (not in `src`):

        $ cd ~/ros2/dingo_ws
        $ git clone <this-repo>

3. Install rosdep (http://wiki.ros.org/rosdep). Since, I have the ROS apt
   repositories, I used the debian-based installation method:

        $ sudo apt-get install python3-rosdep


4. Use `vcs` to clone git repositories into the workspace by referencing the
   `dingo_ws.repos` file in this repository:

        $ cd ~/ros2/dingo_ws
        $ vcs import < /path/to/dingo_setup/dingo_ws.repos

5.
