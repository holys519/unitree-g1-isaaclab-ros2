FROM osrf/ros:humble-desktop

ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=1000

ENV DEBIAN_FRONTEND=noninteractive
ENV CYCLONEDDS_HOME=/opt/cyclonedds
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
ENV ROS_DISTRO=humble

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    curl \
    git \
    iproute2 \
    iputils-ping \
    less \
    libboost-all-dev \
    libeigen3-dev \
    libfmt-dev \
    libglfw3-dev \
    libspdlog-dev \
    libyaml-cpp-dev \
    nano \
    net-tools \
    python3-colcon-common-extensions \
    python3-dev \
    python3-numpy \
    python3-opencv \
    python3-pip \
    python3-vcstool \
    python3-venv \
    ros-humble-rmw-cyclonedds-cpp \
    ros-humble-rosidl-generator-dds-idl \
    ros-humble-teleop-twist-keyboard \
    ros-humble-rviz2 \
    sudo \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch releases/0.10.x https://github.com/eclipse-cyclonedds/cyclonedds.git /tmp/cyclonedds \
    && cmake -S /tmp/cyclonedds -B /tmp/cyclonedds/build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${CYCLONEDDS_HOME} \
    && cmake --build /tmp/cyclonedds/build --target install --parallel "$(nproc)" \
    && rm -rf /tmp/cyclonedds

RUN set -eux; \
    if ! getent group "${USER_GID}" >/dev/null; then groupadd --gid "${USER_GID}" "${USERNAME}"; fi; \
    group_name="$(getent group "${USER_GID}" | cut -d: -f1)"; \
    if ! id -u "${USERNAME}" >/dev/null 2>&1; then useradd --uid "${USER_UID}" --gid "${group_name}" -m -s /bin/bash "${USERNAME}"; fi; \
    echo "${USERNAME} ALL=(root) NOPASSWD:ALL" > "/etc/sudoers.d/${USERNAME}"; \
    chmod 0440 "/etc/sudoers.d/${USERNAME}"

USER ${USERNAME}
WORKDIR /workspaces/robot

RUN python3 -m pip install --user --upgrade pip "setuptools<80" wheel \
    && echo "source /opt/ros/humble/setup.bash" >> "${HOME}/.bashrc" \
    && echo "[ -f /workspaces/robot/scripts/setup_env.sh ] && source /workspaces/robot/scripts/setup_env.sh" >> "${HOME}/.bashrc"
