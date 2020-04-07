## `fzf`

An [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [fzf](https://github.com/junegunn/fzf). 

### Usage

This is a work in progress. Here's my typical function wrapper. It will need a bit more help to be useful this way.

#### Interactive

```sh

fzf() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:fzf" \
    "$@"
}

```
