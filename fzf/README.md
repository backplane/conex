# fzf

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [fzf](https://github.com/junegunn/fzf) the command line fuzzy finder

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/fzf).

## Usage

This is a work in progress. Here's my typical function wrapper. It will need a bit more help to be useful this way.

### Interactive

```sh

fzf() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/fzf" \
    "$@"
}

```
