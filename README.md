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
        $ git clone git@github.com:RIF-Robotics/dingo_setup.git

3. Install vcstool (http://wiki.ros.org/vcstool). Since, I have the ROS apt
   repositories, I used the debian-based installation method:

        $ sudo apt-get install python3-vcstool

4. Use `vcs` to clone git repositories into the workspace by referencing the
   `dingo_ws.repos` file in this repository:

        $ cd ~/ros2/dingo_ws
        $ vcs import < ./dingo_setup/dingo_ws.repos

5. Make sure you have already built the `rif/ros:galactic` docker image in the
   `rif-docker` repository:
   https://github.com/RIF-Robotics/rif-docker/tree/main/dockerfiles/ros_docker

6. Build the `rif/dingo_dev:galactic` docker image using the `dev.dockerfile`
   in this repository:

        $ cd ~/ros2/dingo_ws
        $ docker build -t rif/dingo_dev:galactic -f ./dingo_setup/docker/dev.dockerfile .

## Post-Build Instructions

After you have successfully built the `rif/dingo_dev` image, it may be helpful
to use the `ros_docker` script to develop inside of a ROS docker container. The
`ros_docker` script reads a couple of environment variables to determine the
docker image name to use to start a container. I use `direnv`
(https://direnv.net/) to specify these variables on a directory-specific basis,
but you could also just specify the environment variables in your `~/.bashrc`
file. But this is what I do...

1. Install `direnv` (https://direnv.net/#basic-installation)

        $ sudo apt-get install direnv

   Add the appropriate hook based on your shell:
   https://direnv.net/docs/hook.html

2. Specify the `ROS_VERSION` and `ROS_DOCKER_IMAGE_NAME` environment variable
   in a direnv `.envrc` file:

        $ cd ~/ros2/dingo_ws
        $ echo 'export ROS_VERSION="galactic"' > .envrc
        $ echo 'export ROS_DOCKER_IMAGE_NAME="rif/dingo_dev:galactic"' > .envrc
        $ direnv allow  # Required when you change the .envrc file

3. Now, when you enter the `~/ros2/dingo_ws` workspace, the `.envrc` file will
   be sourced by `direnv`, which sets the `ROS_DOCKER_IMAGE_NAME` variable,
   which will be used by `ros_docker`.

        $ cd ~/ros2/dingo_ws

        # Start the development container
        $ ros_docker up

        # Enter the container
        $ ros_docker connect

        # Build the workspace in the container
        $ colcon build --symlink-install

4. The Docker container can be stopped with `docker` or with `ros_docker`:

        $ ros_docker down

Note: I have found that when I make major changes to the repositories in the
workspace (adding or removing), I have to completely remove the old docker
container for the changes to take affect (docker container prune). `ros_docker`
names containers based on the directory structure of the workspace, so each
workspace will have its own individual container (e.g.,
`ros2_dingo_ws_galactic` vs `ros2_aby_ws_galactic`).
