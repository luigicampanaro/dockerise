##############
# Base image #
##############
FROM pytorch/pytorch:2.4.1-cuda12.4-cudnn9-devel as base

# Getting host's env variables at build time and storing them as ARGs
ARG MAIN_FOLDER_NAME
ARG USERNAME
ARG UID
ARG GID

# Create directories using the argument
RUN mkdir -p "${MAIN_FOLDER_NAME}/src" \
    "${MAIN_FOLDER_NAME}/data" \
    "${MAIN_FOLDER_NAME}/logs"

# Set the working directory to MAIN_FOLDER_NAME
WORKDIR "/${MAIN_FOLDER_NAME}"

# Set the shell to /bin/bash for running commands with Bash syntax and features, instead of sh
SHELL ["/bin/bash", "-c"]

# Set the environment variable to prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Basic install for runtime only
RUN apt-get update \
   && apt-get -y install \
   git \
   && rm -rf /var/lib/apt/lists/*


#####################
# Development image #
#####################
FROM base as dev

# Getting host's env variables at build time and storing them as ARGs
ARG MAIN_FOLDER_NAME
ARG USERNAME
ARG UID
ARG GID

# Set the environment variable to prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Installing basic libraries
RUN apt-get update \
   && apt-get install -y \
   gdb \
   grep \
   htop \
   tmux \
   vim \
   && rm -rf /var/lib/apt/lists/*

# TODO: Add all the vscode install

# Install sudo and create a non-root user
RUN apt-get update \
   && apt-get install -y sudo \
   && rm -rf /var/lib/apt/lists/* \
   && addgroup --gid ${GID} ${USERNAME} \
   && adduser --disabled-password --gecos '' --uid ${UID} --gid ${GID} "${USERNAME}" \
   && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > "/etc/sudoers.d/${USERNAME}" \
   && chown -R ${UID}:${GID} "/${MAIN_FOLDER_NAME}"

# Allowing for interactions
ENV DEBIAN_FRONTEND=dialog

# switches the active user from the default root user to the user specified by the developer user
USER "${USERNAME}"

RUN sudo apt-get update

#####################
# Development image #
#####################
FROM dev as dev_vscode

# Getting host's env variables at build time and storing them as ARGs
ARG MAIN_FOLDER_NAME
ARG USERNAME
ARG UID
ARG GID

# Set the environment variable to prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

RUN sudo apt-get update && \
    sudo apt-get install -y \
    wget \
    gpg 

RUN sudo apt-get update && \
    sudo apt-get install -y \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcairo2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxkbfile1 \
    libxrandr2 \
    xdg-utils 

# Install vscode
RUN sudo rm -rf /var/lib/apt/lists/* \
   && wget -O vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868 \
   && echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections \
   && sudo apt install apt-transport-https \
   && sudo apt update \
   && sudo dpkg -i vscode.deb \
   && echo "alias code='code --no-sandbox'" >> ~/.bashrc \
   && rm -rf vscode.deb

# Install Python extension for VSCode
RUN /usr/share/code/bin/code --install-extension ms-python.python

# Allowing for interactions
ENV DEBIAN_FRONTEND=dialog