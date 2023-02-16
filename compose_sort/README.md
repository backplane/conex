# compose_sort

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of `compose_sort`, a CLI utility for sorting docker-compose files

The utility works best when the input comes in the normalized format produced by the [`docker-compose config`](https://docs.docker.com/compose/reference/config/) command.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/compose_sort).

## Usage

```
usage: compose_sort [-h] [input_file]

command-line utility for sorting docker-compose.yml files

positional arguments:
  input_file  the file to sort, if not specified STDIN will be used

optional arguments:
  -h, --help  show this help message and exit
```

### Interactive

The following one-liner invocation can be used to quickly print a sorted resolved version of a docker composition:

```sh
docker-compose config --resolve-image-digests | docker run --rm -i backplane/compose_sort
```

The following shell function can also assist in running this image interactively:

```sh

compose_sort() {
  docker run \
    --rm \
    --interactive \
    --volume "$(pwd):/work" \
    "backplane/compose_sort" \
    "$@"
}

```
