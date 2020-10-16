DISCLAIMER: This is a work in progress it will highly susceptible to change!

# Prerequisites

Before you can run this Docker container you need to [install the Nvidia container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#installing-on-ubuntu-and-debian) on the system where you want to run the GPU accelerated Docker instances on.

# Installation

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
docker build -t adf .
```

# Usage

Now you can run the Docker container with the build image:

```
docker run --init --runtime=nvidia --name=adf -h {HOSTNAME} --rm -i -v /tmp/.X11-unix/X{DISPLAYNR}:/tmp/.X11-unix/X{DISPLAYNR} -v {ADFHOME}:/sw/adf -p 5902:5902 adf
```

Where:

- `HOSTNAME`: Is the hostname of your system this Docker container is going to run on. This hostname is used in the adf licensing file.
- `DISPLAYNR`: The display number your system is running its 3D X server on (usually 0). 
- `ADFHOME`: The ADF directory on your system containing the binaries and licensing file. 

Now go to your browser and go to [https://localhost:5902](https://localhost:5902). This will open the noVNC client-side, now enter the One-time-password (OTP) that was given after starting the Docker container. ADF should be opened by default, if not you can still open it with:

```
docker exec -ti adf -c "cd /sw/adf/ && . ./adfbashrc.sh && vglrun -d :{DISPLAYNR} adfjobs"
```

Where:

- `DISPLAYNR`: The display number your system is running its 3D X server on (usually 0). 