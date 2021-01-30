# chardet

[`python:3-alpine`](https://hub.docker.com/_/python/)-based dockerization of [chardet](https://github.com/chardet/chardet), The Universal Character Encoding Detector

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

chardet() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:chardet" \
    "$@"
}

```
