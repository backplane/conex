# 7z

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [p7zip](https://www.7-zip.org/)

As the site says:

> 7-Zip is a file archiver with a high compression ratio.

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
    "galvanist/conex:7z" \
    "$@"
}

```
