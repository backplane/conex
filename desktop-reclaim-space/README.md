# desktop-reclaim-space

A simple tool to reclaim space inside the Docker Desktop VM

This image is a based on the code hosted at <https://github.com/djs55/desktop-reclaim-space> which is the source for the image [docker/desktop-reclaim-space](https://hub.docker.com/r/docker/desktop-reclaim-space/tags). I have provided this image build because `docker/desktop-reclaim-space` is currently not available for ARM processors (As of 16-Feb-2023 [there is an open issue to address this](https://github.com/djs55/desktop-reclaim-space/issues/2)).

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/desktop-reclaim-space).

## Usage (macOS)

**Before you start:** Make sure you've deleted any unnecessary images and volumes from Docker before you run anything here. See the [Docker Desktop documentation](https://docs.docker.com/desktop/faqs/macfaqs/#what-if-the-file-is-too-big) for some help with that.

1. First have a look at the size of your docker VM image:

    ```shell=/bin/sh
    du -h ~/Library/Containers/com.docker.docker/Data/vms/0/data/*
    ```

    According to the [Docker Desktop documentation](https://docs.docker.com/desktop/faqs/macfaqs/#what-if-the-file-is-too-big) if you have a `.raw` file, then the effects of running the command in step 2 will be apparent in a few seconds, alternatively if you have a `.qcow2` file it make a few minutes for changes to appear.

2. Run the container:

    ```shell=/bin/sh
    docker run --privileged --pid=host backplane/desktop-reclaim-space
    ```

3. See what effect the command had on your image size:

    ```shell=/bin/sh
    du -h ~/Library/Containers/com.docker.docker/Data/vms/0/data/*
    ```

## Notes

* **IMPORTANT SECURITY NOTE**: As a general rule you don't want to run containers with `--privileged` because this can let malicious containers do bad things. We're using it here to enable the us to escape into the Linux VM that powers Docker Desktop. Malware could use it to escape into other containers, persist itself in volumes and in the VM, and access as many paths from your mac as you have shared with Docker. The risks are real. If you want to be extra safe you can view the source of the Docker file and build it yourself.
* The base image for this container is [justincormack/nsenter1](https://hub.docker.com/r/justincormack/nsenter1) which is created from [the source code here](https://github.com/justincormack/nsenter1). ([Justin Cormack](https://www.docker.com/author/justin-cormack/) is the Docker CTO and a key engineer of the Docker Desktop product.) `nsenter1` is itself a very simple image which you can build yourself for extra safety.
* An alternative to using this container is to just use the Justin Cormack's `nsenter1` image directly with this command:

    ```sh
    docker run \
    --privileged \
    --pid host \
    --rm \
    --entrypoint /usr/bin/nsenter1 \
    justincormack/nsenter1 \
        /bin/sh -c \
        'for mnt in /var/lib /containers/services; do fstrim -v "$mnt"; done'
    ```