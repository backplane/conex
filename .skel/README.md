## `imagename`

### Usage

#### Interactive

```sh

imagename() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:" \
    "$@"
}

```

#### As Build Stage

```Dockerfile
FROM galvanist/conex: as builder



```
