# Dingo Setup

Setup instructions and docker files for Dingo.

## Install Dependencies:

### git, docker, docker-compose

### vcs

http://wiki.ros.org/vcstool

## Setup Workspace and Clone dingo_setup

    $ mkdir -p ~/ros2/dingo_ws/src
    $ cd ~/ros2/dingo_ws
    $ git clone git@github.com:cosmosrobotics/dingo_setup.git

### Clone Repositories

    $ cd ~/ros2/dingo_ws/dingo_setup
    $ vcs import ../src < dingo.repos

### Build Docker Development Environment

    $ cd dingo_setup
    $ docker-compose build

### Use Docker Development Environment

Start Docker development environment and enter:

    $ docker-compose up -d dev-nvidia
    $ docker exec -it dingo_galactic_nvidia /bin/bash

Stop Docker container

    $ docker-compose stop

Remove container (will remove any of your changes in the Docker container, so
don't do this unless you want to start fresh):

    $ docker-compose down
