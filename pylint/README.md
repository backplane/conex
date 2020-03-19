## `pylint`

### Usage

#### Interactive

```sh

pylint() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:pylint" \
    "$@"
}

```
