# imagename

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of 

[`debian:stable-slim`](https://hub.docker.com/_/debian/)-based dockerization of 

[`scratch`](https://hub.docker.com/_/scratch/)-based single-binary container image which 

As the site says:

>
>

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

imagename() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/imagename" \
    "$@"
}

```

### As Build Stage

```Dockerfile
FROM backplane/imagename as builder


```
