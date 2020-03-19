## [`goenv`](goenv/Dockerfile)

### Usage

#### Interactive

This shell function demonstrates using this container in place of having the actual go installation.

```sh
goenv() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/home/user/go/src/local" \
    "$@" \
    galvanist/conex:goenv
}
```

Then you just cd to a directory with a go project (or an empty directory) and run `goenv`.
