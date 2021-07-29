# wpa_passphrase

[`scratch`](https://hub.docker.com/_/scratch/)-based container image which contains the `wpa_passphrase` utility from [Jouni Malinen's wpa_supplicant package](https://w1.fi/wpa_supplicant)

As the [man page for wpa_passphrase(8)](https://manpages.debian.org/unstable/wpasupplicant/wpa_passphrase.8.en.html) says:

> wpa_passphrase pre-computes PSK entries for network configuration blocks of a `wpa_supplicant.conf` file. An ASCII passphrase and SSID are used to generate a 256-bit PSK

## Usage

```
usage: wpa_passphrase <ssid> [passphrase]

If passphrase is left out, it will be read from stdin
```

### Interactive

The following shell function can assist in running this image interactively:

```sh

wpa_passphrase() {
  docker run \
    --rm \
    --interactive \
    --tty \
    "backplane/wpa_passphrase" \
    "$@"
}

```
