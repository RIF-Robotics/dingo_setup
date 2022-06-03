FROM osrf/ros:galactic-desktop-focal

MAINTAINER Kevin DeMarco
ENV DEBIAN_FRONTEND noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get install -y \
       ros-galactic-gazebo-ros \
       ros-galactic-geometry-msgs \
       ros-galactic-std-msgs \
    && rm -rf /var/lib/apt/lists/*

# Create the "ros" user, add user to sudo group
ENV USERNAME ros
RUN adduser --disabled-password --gecos '' $USERNAME \
    && usermod  --uid 1000 $USERNAME \
    && groupmod --gid 1000 $USERNAME \
    && usermod --shell /bin/bash $USERNAME \
    && adduser $USERNAME sudo \
    && adduser $USERNAME dialout \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# # Build and install librealsense
# RUN mkdir -p /repos/3rd-party \
#     && cd /repos/3rd-party \
#     && git clone https://github.com/IntelRealSense/librealsense.git \
#     && mkdir -p ./librealsense/build \
#     && cd librealsense/build \
#     && cmake .. \
#     && make -j4 \
#     && make install

# # librealsense dependencies?
# RUN apt-get update \
#     && apt-get install -y \
#        libglfw3-dev \
#        libgl1-mesa-dev \
#        libglu1-mesa-dev \
#     && rm -rf /var/lib/apt/lists/*

USER $USERNAME

RUN mkdir -p /home/$USERNAME/workspace/src

WORKDIR /home/$USERNAME/workspace

# Copy code in
COPY --chown=ros ./src ./src

# Install code dependencies
RUN mkdir -p /home/$USERNAME/.ros \
    && sudo apt-get update \
    && rosdep update \
    && sudo rosdep install --from-paths src --ignore-src -r -y --rosdistro=galactic

# Build code
RUN source /opt/ros/galactic/setup.bash \
    && colcon build --symlink-install

# Setup .bashrc environment
RUN echo 'source ~/workspace/install/setup.bash' >> /home/$USERNAME/.bashrc \
    && echo 'source /usr/share/gazebo/setup.sh' >> /home/$USERNAME/.bashrc \
    && mkdir -p /home/$USERNAME/workspace/src
