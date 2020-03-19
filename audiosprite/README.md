## [`audiosprite`](audiosprite/Dockerfile)

This is an alpine-based dockerization of [audiosprite](https://github.com/tonistiigi/audiosprite).

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
