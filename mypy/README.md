# mypy

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [mypy](https://github.com/python/mypy), the "optional static type checker for Python"

As the site says:

> Mypy is an optional static type checker for Python. You can add type hints (PEP 484) to your Python programs, and use mypy to type check them statically. Find bugs in your programs without even running them!
>
> You can mix dynamic and static typing in your programs. You can always fall back to dynamic typing when static typing is not convenient, such as for legacy code.

The image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/mypy).

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

mypy() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/mypy" \
    "$@"
}

```

