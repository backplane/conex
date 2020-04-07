## `json-server`

This is an [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [json-server](https://github.com/typicode/json-server).

### Usage

#### Interactive

```sh

json-server() {
  docker run \
    --rm \
    --init \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    --publish "3000:3000" \
    "galvanist/conex:json-server" \
    --host 0.0.0.0 \
    "$@"
}

```
