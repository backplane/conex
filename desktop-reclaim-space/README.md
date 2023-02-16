# desktop-reclaim-space

A simple tool to reclaim space inside the Docker Desktop VM

This image is a based on the code hosted at <https://github.com/djs55/desktop-reclaim-space> which is the source for the image [docker/desktop-reclaim-space](https://hub.docker.com/r/docker/desktop-reclaim-space/tags). I have imported this code and provided this image build because `docker/desktop-reclaim-space` is currently not available for ARM processors.

The image source code is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/desktop-reclaim-space).

## Usage (macOS)

1. First have a look at the size of your docker VM image:

    ```shell=/bin/sh
    du -h ~/Library/Containers/com.docker.docker/Data/vms/0/data/*
    ```

    According to [djs' documentation](https://github.com/djs55/desktop-reclaim-space) if you have a `.raw` file, running this container will produce an immediate effect. If you have a `.qcow2` file it make take some time for the change to take effect.

2. Run the container:

    ```shell=/bin/sh
    docker run --privileged --pid=host backplane/desktop-reclaim-space
    ```

3. See what effect the command had on your image size:

    ```shell=/bin/sh
    du -h ~/Library/Containers/com.docker.docker/Data/vms/0/data/*
    ```

## Notes

* **IMPORTANT SECURITY NOTE**: As a general rule you don't want to run containers with `--privileged` because this can let malicious containers do bad things. We're using it here to enable the container to escape into the Linux VM that powers Docker Desktop. Malware could use it to escape into other containers, persist itself in volumes and in the VM, and access as many paths from your mac as you have shared with Docker. The risks are real. If you want to be extra safe you can view the source of the Docker file and build it yourself.
* The base image for this container is [justincormack/nsenter1](https://hub.docker.com/r/justincormack/nsenter1) based on [the source code here](https://github.com/justincormack/nsenter1). ([Justin Cormack](https://www.docker.com/author/justin-cormack/) is the Docker CTO and a key engineer of the Docker Desktop product.) `nsenter1` is itself a very simple image which you can build yourself for extra safety.
