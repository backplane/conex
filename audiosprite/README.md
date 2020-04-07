## `audiosprite`

This is an [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [audiosprite](https://github.com/tonistiigi/audiosprite).

### Usage

#### Interactive

```sh
audiosprite() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/data" \
    "galvanist/conex:audiosprite" \
    "$@"
}
```
