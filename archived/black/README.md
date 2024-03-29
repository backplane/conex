# black

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [black](https://black.readthedocs.io/en/stable/), the python code formatter

As the [github repo](https://github.com/psf/black) says:

> Black is the uncompromising Python code formatter. By using it, you agree to cede control over minutiae of hand-formatting. In return, Black gives you speed, determinism, and freedom from pycodestyle nagging about formatting. You will save time and mental energy for more important matters.
>
>Blackened code looks the same regardless of the project you're reading. Formatting becomes transparent after a while and you can focus on the content instead.
>
>Black makes code review faster by producing the smallest diffs possible.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/black).

## Usage

### Interactive

I use this image with something like the following shell function:

```sh

black() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/black" \
    "$@"
}

```
