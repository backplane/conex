# `imagename`

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of

[`debian:stable-slim`](https://hub.docker.com/_/debian/)-based dockerization of 

As the site says:

>
>

## Usage

### Interactive

The following shell function can assist in running this container interactively:

```sh

imagename() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:imagename" \
    "$@"
}

```

### As Build Stage

```Dockerfile
FROM galvanist/conex:imagename as builder


```
