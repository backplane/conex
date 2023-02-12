# chardet

[`python:3-alpine`](https://hub.docker.com/_/python/)-based dockerization of [chardet](https://github.com/chardet/chardet), The Universal Character Encoding Detector

The image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/chardet).

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
    "backplane/chardet" \
    "$@"
}

```
