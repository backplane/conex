# adb

[`debian:stable-slim`](https://hub.docker.com/_/debian/)-based dockerization of the [Android Debug Bridge](https://developer.android.com/studio/command-line/adb)

Note: This version uses the [debian adb package](https://packages.debian.org/buster/adb) only -- previously I was getting the code directly from [google's android platform utils for linux release](https://dl.google.com/android/repository/platform-tools-latest-linux.zip) and including other parts of the platform utils in this images.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/adb).

## Usage

### Interactive

something like this... still working on the params

```sh

adb() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --device "/dev/bus/usb/001/004" \
    --volume "$(pwd):/work" \
    "backplane/adb" \
    "$@"
}

```
