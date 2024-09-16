# 🧩 ML Development Environment Setup

This project provides a streamlined way to set up an out-of-the-box development environment for machine learning projects using PyTorch, a GPU, and Visual Studio Code (VSCode). The environment is created using Docker to ensure a consistent and isolated setup.

## 🚀 Features

- **PyTorch with GPU support**: Pre-configured for high-performance ML development.
- **VSCode Integration**: Full VSCode GUI interface inside the container.
- **Pre-configured Folders**: Automatically creates `src`, `data`, and `logs` directories.
- **Easy Setup**: A single script to initialize the environment.

## 🛠️ Prerequisites

1. **Docker**: Ensure Docker is installed and running on your system. 🐳
2. **NVIDIA Container Toolkit**: Ensure the NVIDIA Container Toolkit is installed to enable GPU support within Docker.
3. **Docker Compose**: Required for building and running the Docker container. 📦

## Getting Started

Follow these steps to set up your development environment:

### 1. Prepare Your Project Directory

Create an empty directory for your project. The name of this directory will be used as part of the container's name.

```bash
mkdir my_ml_project
cd my_ml_project
```

### 2. Clone the Repository

Clone this repository into the newly created directory:

```bash
git clone https://github.com/luigicampanaro/dockerise.git
```

### 3. Make the Script Executable
Before running the `init_project.sh` script, make it executable:


```bash
cd dockerise
chmod +x init_project.sh
```

### 4.  Initialize the Project
Run the `init_project.sh` script to set up the project structure and build the Docker container.

```bash
./init_project.sh
```

This script will:

- Create `src`, `data`, and `logs` folders in your project directory. 📂
- Build automatically the Docker container based on the provided Dockerfile and `docker-compose.yml`. 🏗️

### 5.  Start the Development Environment
Once the build process completes, start the development environment using Docker Compose:

```bash
docker-compose up
```

This will:

- Start a container with PyTorch, GPU support, and VSCode installed. 🚀
- Mount your `src`, `data`, and `logs` directories into the container. 🔗
- Allow you to interact with VSCode and other tools inside the container. 🛠️

To check that the container is running, use:

```bash
docker ps -a
```

Then, use the correct `CONTAINER ID` to connect to the container:

docker exec -it <CONTAINER ID> /bin/bash


### 6. Access VSCode
Once inside the container, you can access VSCode by running:

```bash
code
```

You can check the GPU setup by typing:

```bash
nvidia-smi
```

### 7. Working with Your Project
1. Clone Repositories: Inside the container, clone your ML repositories into the src folder. These are volumes mounted in Docker, so changes will be reflected in your host system. 🔄
2. Develop and Train Models: Use the pre-configured environment to start developing and training your models. 🧠💻

### Dockerfile Overview
The Dockerfile sets up a multi-stage build process:

- Base Image: Starts with the PyTorch 2.4.1 image with CUDA 12.4 and cuDNN 9 on Ubuntu 22.04 and installs essential utilities. 🖥️
- Development Image: Adds development tools (e.g. vim, htop, etc). 🛠️
- VSCode Image: Installs VSCode and necessary dependencies. 💡

## 🔍 Acknowledgments
This project was freely inspired by the [docker-for-robotics](https://github.com/2b-t/docker-for-robotics) repository. Thank you to the creators for their work and ideas.

### 📜 License
This project is licensed under the [MIT License](https://opensource.org/licenses/MIT). See the LICENSE file for details. 📝