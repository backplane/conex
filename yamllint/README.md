# yamllint

[`python:3.10-alpine`](https://hub.docker.com/_/python/)-based dockerization of [yamllint](https://yamllint.readthedocs.io/en/stable/index.html), the linter for YAML files.

As the site says:

> yamllint does not only check for syntax validity, but for weirdnesses like key repetition and cosmetic problems such as lines length, trailing spaces, indentation, etc.

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

yamllint() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/yamllint" \
    "$@"
}

```
