# yq

[`scratch`](https://hub.docker.com/_/scratch/)-based dockerization of [yq](https://mikefarah.github.io/yq/), the command-line YAML processor.

As the site says:

> yq uses `jq` like syntax but works with yaml files as well as json

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/yq).

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

yq() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/yq" \
    "$@"
}

```
