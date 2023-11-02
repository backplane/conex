# minidlna

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [MiniDLNA](https://sourceforge.net/projects/minidlna/).

As the site says:

> ReadyMedia (formerly known as MiniDLNA) is a simple media server software, with the aim of being fully compliant with DLNA/UPnP-AV clients. It was originally developed by a NETGEAR employee for the ReadyNAS product line.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/minidlna).

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

minidlna() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/data" \
    "backplane/minidlna" \
    "$@"
}

```
