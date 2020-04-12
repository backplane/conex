# `qrencode`

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [qrencode](https://fukuchi.org/works/qrencode/), the command-line utility for generating QR codes in various formats (PNG, terminal text, etc.)

As the site says, `qrencode` is:

> for encoding data in a QR Code symbol, a 2D symbology that can be scanned by handy terminals such as a mobile phone[s] with [cameras]. The capacity of QR Code is up to 7000 digits or 4000 characters and has high robustness.

## Usage

### Interactive

The following shell function can assist in running this container interactively:

```sh

qrencode() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:qrencode" \
    "$@"
}

```
