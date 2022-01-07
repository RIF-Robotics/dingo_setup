# About

Setup instructions and docker files for Dingo.

# Dingo Setup

## Install Dependencies:

* Docker: https://docs.docker.com/engine/install/ubuntu/
* docker-compose: https://docs.docker.com/compose/install/
* vcs: http://wiki.ros.org/vcstool

I prefer `sudo apt install python3-vcstool` using the ROS repositories

## First Time Instructions

1. Setup Workspace and Clone dingo_setup

        $ mkdir -p ~/ros2/dingo_ws/src
        $ cd ~/ros2/dingo_ws
        $ git clone git@github.com:RIF-Robotics/dingo_setup.git

2.  Clone Repositories

        $ cd ~/ros2/dingo_ws/dingo_setup
        $ vcs import ../src < dingo.repos

    **NOTE**: Regularly execute the following to keep the repositories up to
    date:

        $ vcs pull ../src

3. Build Docker development environment

        $ cd ~/ros2/dingo_ws/dingo_setup
        $ docker-compose build

## Use Docker Development Environment

Start Docker development environment and enter:

    $ cd ~/ros2/dingo_ws/dingo_setup
    $ docker-compose up -d dev-nvidia
    $ docker exec -it dingo_galactic_nvidia /bin/bash

**NOTE**: You can open as many terminals as needed with the last command. Each
command will drop you inside the same container.

Stop Docker container

    $ cd ~/ros2/dingo_ws/dingo_setup
    $ docker-compose stop

Remove container (will remove any of your changes in the Docker container, so
don't do this unless you want to start fresh):

    $ cd ~/ros2/dingo_ws/dingo_setup
    $ docker-compose down

## Dingo in Simulation (with a pre-built map)

1. Start Gazebo:

        $ ros2 launch dingo_gazebo empty_world.launch.py

2. Start the Nav2 stack:

        $ ros2 launch dingo_navigation nav2.launch.py

3. Start Rviz:

        $ ros2 launch dingo_navigation rviz.launch.py

AMCL requires an initial 2D pose estimate. In rviz, click on the "2D Pose
Estimate" button and click and drag on the rviz map to approximate the 2D pose
of the actual robot in Gazebo.

You can now send navigation goals to the robot by clicking on the "Nav2 Goal"
button in rviz and clicking on the map.

## Dingo in Simulation (build a new map)

1. Make sure the source code is built

        $ cd ~/workspace
        $ colcon build

2. Start Gazebo:

        $ ros2 launch dingo_gazebo empty_world.launch.py

3. Start the Nav2 stack with the slam toolbox enabled:

        $ ros2 launch dingo_navigation nav2.launch.py build_map:=True

4. Start Rviz:

        $ ros2 launch dingo_navigation rviz.launch.py

You now need to move the robot around the space to build the map. You can use
the "Nav2 Goal" button in rviz to drop goal poses or you can manually
teleoperate the robot with the keyboard.

4. Teleoperate the robot with the keyboard

        $ ros2 run teleop_twist_keyboard teleop_twist_keyboard

5. Save the new map

After the map has been adequately explored, you can save the map with the
command:

    $ ros2 service call /map_saver/save_map nav2_msgs/srv/SaveMap

This command sends a request to the map saver node to save the map to the ROS
workspace.
