# json-server

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [json-server](https://github.com/typicode/json-server)

The image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/json-server).

## Usage

### Interactive

```sh

json_server() {
  docker run \
    --rm \
    --init \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    --publish "3000:3000" \
    "backplane/json-server" \
    --host 0.0.0.0 \
    "$@"
}

```
