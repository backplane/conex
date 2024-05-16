# desktop-reclaim-space

A simple tool to reclaim space inside the Docker Desktop VM

This image is based on the code hosted at <https://github.com/djs55/desktop-reclaim-space> which is the source for the image [docker/desktop-reclaim-space](https://hub.docker.com/r/docker/desktop-reclaim-space/tags). We provide this image because `docker/desktop-reclaim-space` is currently not available for ARM processors (As of 16-Feb-2023 [there is an open issue to address this](https://github.com/djs55/desktop-reclaim-space/issues/2)).

**Normally you should not need to run a `desktop-reclaim-space` container!** The docker desktop virtual machine includes a process called [`trim-after-delete`](https://github.com/linuxkit/linuxkit/tree/master/pkg/trim-after-delete) which automatically returns unused disk space within 10 seconds of a docker container, image, volume, or builder being deleted (it may take slightly longer to see the change if you have a `.qcow2` disk image).

Even though file deletes which happen *inside* of running containers *do not* trigger `trim-after-delete`, the next time it is triggered for any reason that space will still be reclaimed. So if you run `docker run --rm --privileged --pid=host docker/desktop-reclaim-space` you are calling the reclaim process (`fstrim`) twice - once when the container does it and again after `--rm` removes the container.

**Instead of using this kind of image** (and having to use the risky `--privileged` flag), you can instead do anything that causes a docker resource delete (such as running the `66.5kB` no-op image [backplane/true](https://hub.docker.com/r/backplane/true) with `docker run --rm backplane/true`).

To make *this* image potentially useful for something, we have turned it into a run-forever container which calls `fstrim` every `$INTERVAL` seconds. If you anticipate some heavy deletes happening in a long-running process you can run this in the background to regularly reclaim the disk space for the docker host. In most cases this is not necessary.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/desktop-reclaim-space).

## Usage (macOS)

**Before you start:** See the [Docker Desktop documentation](https://docs.docker.com/desktop/faqs/macfaqs/#what-if-the-file-is-too-big) for some help cleaning up your system.

0. Make sure you've read the above paragraphs and have a good reason to proceed, understand the risks, and know what you're doing.

1. First have a look at the size of your docker desktop VM image:

    ```shell=/bin/sh
    du -h ~/Library/Containers/com.docker.docker/Data/vms/0/data/*
    ```

    According to the [Docker Desktop documentation](https://docs.docker.com/desktop/faqs/macfaqs/#what-if-the-file-is-too-big) if you have a `.raw` file, then the effects of running the reclaim command will be apparent after a few seconds, alternatively if you have a `.qcow2` file it may take a few minutes for changes to appear.

2. Start the container in the background:

    ```shell=/bin/sh
    docker run -e INTERVAL=900 -d --privileged --pid=host backplane/desktop-reclaim-space
    ```

3. See what effect the command had on your image size:

    ```shell=/bin/sh
    du -h ~/Library/Containers/com.docker.docker/Data/vms/0/data/*
    ```

## Notes

* **IMPORTANT SECURITY NOTE**: As a general rule you don't want to run containers with `--privileged` because this can let malicious or poorly-written containers do bad things. We're using it here to enable the us to escape into the Linux VM that powers Docker Desktop. Malware could use it to escape into other containers, persist itself in volumes and in the VM, and access as many paths from your mac as you have shared with Docker. The risks are real.
* The base image for this container is [justincormack/nsenter1](https://hub.docker.com/r/justincormack/nsenter1) which is created from the [source code here](https://github.com/justincormack/nsenter1). ([Justin Cormack](https://www.docker.com/author/justin-cormack/) is the Docker CTO and a key engineer of the Docker Desktop product.) `nsenter1` is itself a very simple image which you can build yourself for extra safety.
* Yet another alternative to using *this* container image is to use Justin Cormack's `nsenter1` image directly like this:

    ```sh
    docker run \
    --privileged \
    --pid host \
    --rm \
    --entrypoint /usr/bin/nsenter1 \
    justincormack/nsenter1 \
    /sbin/fstrim -v /var/lib
    ```