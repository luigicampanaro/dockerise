##############
# Base image #
##############
FROM nvcr.io/nvidia/pytorch:24.08-py3 as base

# Getting host's env variables at build time and storing them as ARGs
ARG MAIN_FOLDER_NAME
ARG USERNAME
ARG UID
ARG GID

# Set the shell to /bin/bash for running commands with Bash syntax and features, instead of sh
SHELL ["/bin/bash", "-c"]

# Set environment variable to prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Create a non-root user with the home directory in /home/${USERNAME}
RUN apt-get update \
    && apt-get install -y sudo \
    && addgroup --gid ${GID} ${USERNAME} \
    && adduser --disabled-password --gecos '' --uid ${UID} --gid ${GID} --home "/home/${USERNAME}" "${USERNAME}" \
    && echo "${USERNAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && mkdir -p "/home/${USERNAME}/${MAIN_FOLDER_NAME}/src" \
    "/home/${USERNAME}/${MAIN_FOLDER_NAME}/data" \
    "/home/${USERNAME}/${MAIN_FOLDER_NAME}/logs" \
    && chown -R ${UID}:${GID} "/home/${USERNAME}"

# Install basic utilities for runtime
RUN apt-get update \
   && apt-get -y install \
   git \
   vim \
   htop \
   && rm -rf /var/lib/apt/lists/*

# Set the PATH environment variable globally for all users
ENV PATH="/home/${USERNAME}/.local/bin:$PATH"

# Switch to the non-root user
USER "${USERNAME}"

# Install poetry for Python package management
RUN pip install poetry

# Set the working directory to the main project folder (inside the user home directory)
WORKDIR "/home/${USERNAME}/${MAIN_FOLDER_NAME}"

#####################
# Development image #
#####################
FROM base as dev

# Install development tools
RUN sudo apt-get update \
   && sudo apt-get install -y \
   gdb \
   grep \
   tmux \
   && sudo rm -rf /var/lib/apt/lists/*

# Update apt under the new user
RUN sudo apt-get update

# Allowing for interactions
ENV DEBIAN_FRONTEND=dialog

#####################
# VSCode Development Image #
#####################
FROM dev as dev_vscode

ENV DEBIAN_FRONTEND=noninteractive

# Install VSCode dependencies
RUN sudo apt-get update && \
    sudo apt-get install -y \
    wget \
    gpg \
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
    xdg-utils && \
    sudo rm -rf /var/lib/apt/lists/*

# Install VSCode
RUN wget -O vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868 \
   && sudo apt install apt-transport-https \
   && sudo apt update \
   && sudo dpkg -i vscode.deb \
   && sudo rm -rf vscode.deb

# Add VSCode alias in the user's home directory bashrc
RUN echo "alias code='code --no-sandbox'" >> "/home/${USERNAME}/.bashrc"

# Install extensions for VSCode
RUN /usr/share/code/bin/code --install-extension ms-python.python # Python
RUN /usr/share/code/bin/code --install-extension zeshuaro.vscode-python-poetry # Poetry
RUN /usr/share/code/bin/code --install-extension LittleFoxTeam.vscode-python-test-adapter

# Allowing for interactions
ENV DEBIAN_FRONTEND=dialog
