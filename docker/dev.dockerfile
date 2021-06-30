FROM rif/ros:galactic

RUN sudo apt-get update \
    && sudo apt-get install -y \
        libncurses5-dev \
        ros-galactic-xacro

COPY --chown=ros ./src ./src

RUN rosdep update \
    && rosdep install --from-paths src --ignore-src -r -y --rosdistro=galactic

RUN source /opt/ros/galactic/setup.bash \
    && colcon build --symlink-install
