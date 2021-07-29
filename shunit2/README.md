# shunit2

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [shUnit2](https://github.com/kward/shunit2/), the "xUnit-based unit test framework for Bourne-based shell scripts."

## Usage

The image will set the `SHUNIT_PATH` environment variable (to `/shunit`). It will provide the latest version of shunit at `/shunit`. At the end of your shell tests, load shunit with something like the following line:

```sh
# shellcheck source=/dev/null
. ${SHUNIT_PATH:-../shunit}
```

or simply

```
# shellcheck source=/dev/null
. "$SHUNIT_PATH"
```

Then with the interactive shunit2 alias below, 


### Interactive

```sh

shunit2() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/shunit2" \
    "$@"
}

```

Simply run `shunit2` from the project root directory.
