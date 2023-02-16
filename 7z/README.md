# 7z

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [p7zip](https://www.7-zip.org/)

As the site says:

> 7-Zip is a file archiver with a high compression ratio.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/7z).

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

p7zip() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/7z" \
    "$@"
}

```
