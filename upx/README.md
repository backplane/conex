# upx

[`alpine:edge`](https://hub.docker.com/_/alpine)-based dockerization of [`UPX`](https://github.com/upx/upx) - the "Ultimate Packer for eXecutables"

As the site says:

> UPX is an advanced executable file compressor. UPX will typically
reduce the file size of programs and DLLs by around 50%-70%, thus
reducing disk space, network load times, download times and
other distribution and storage costs.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/upx).

## Usage

At the moment, this container is simply an Alpine Linux container with [the latest release](https://github.com/upx/upx/releases) of the UPX binary installed in the /bin directory