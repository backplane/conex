## `pycodestyle`

### Usage

#### Interactive

```sh

pycodestyle() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:pycodestyle" \
    "$@"
}

```
