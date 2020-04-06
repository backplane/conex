## `adb`

This is a [`debian:stable-slim`](https://hub.docker.com/_/debian/)-based dockerization of the Android [SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools) (using the [debian adb package](https://packages.debian.org/buster/adb)).

Note: In an earlier variant I was getting the package directly from <https://dl.google.com/android/repository/platform-tools-latest-linux.zip>.

### Usage

#### Interactive

something like this... still working on the params

```sh

adb() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --device "/dev/bus/usb/001/004" \
    --volume "$(pwd):/work" \
    "galvanist/conex:adb" \
    "$@"
}

```
