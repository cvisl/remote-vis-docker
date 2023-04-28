# Docker containers for remote visaulization

This repository contains 2 container definitions for remote visualization, one uses software rendering with the CPU through Mesa 3D graphics library and the other uses the GPU for rendering with the Nvidia drivers and OpenGL.

## Prerequisites

### CPU

No prerequisites, you can go to installation directly.

### GPU

Before you can run the GPU accelarated Docker container you need to [install the Nvidia container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) on the system where you want to run the GPU accelerated Docker instances on.

## Installation

1. Give `root` access to the running X-server:

```
xhost +si:localuser:root
```

2. In this repository's root directory place a SSL certificate file (name `self.pem`) or make one yourself:

```
openssl req -new -x509 -days 365 -nodes -out self.pem -keyout self.pem
```

3. Next build the Docker image:

```
sudo docker build -f {Dockerfile.cpu or Dockerfile.nvidia} -t remotevis .
```

## Usage

Now you can run the Docker container with the build image:

**CPU:**

```
sudo docker run --name=remotevis -h {HOSTNAME} --rm -i -v /tmp/.X11-unix/X{DISPLAYNR}:/tmp/.X11-unix/X{DISPLAYNR} -v {SOFTWAREDIR}:/sw -v {DATA DIRECTORY}:/data -p 5902:5902 remotevis
```

**GPU:**

```
docker run --init --runtime=nvidia --name=remotevis -h {HOSTNAME} --rm -i -v /tmp/.X11-unix/X{DISPLAYNR}:/tmp/.X11-unix/X{DISPLAYNR} -v {SOFTWAREDIR}:/sw -v {DATADIR}:/data -p 5902:5902 remotevis
```

Where:

- `HOSTNAME`: Is the hostname of your system this Docker container is going to run on. This hostname can be used for licensing files of the software used in the container.
- `DISPLAYNR`: The display number your system is running its 3D X server on (usually 0). 
- `SOFTWAREDIR`: The location where you have installed all your binaries of the software you want to used in the remote visualization session.
- `DATADIR`: The location where you have your data stored you want to visualize.


If you want to open a program directly on the startup of the VNC container you can provide a `software-start-up.sh` script containing the commands to start the program. If you would then connect to the remote visualization session it opens the program automatically.

Now go to your browser and go to [https://localhost:5902](https://localhost:5902). This will open the noVNC client-side. The program should be opened by default, if not you can still open it with:

```
docker exec -ti remotevis -c "vglrun {PROGRAM_EXECUTABLE}"
```

Or you can do it in the remote visualization desktop environment itself.