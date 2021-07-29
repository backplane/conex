# wireguard

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [WireGuard](https://www.wireguard.com/), the free open-source VPN software

As the site says:

> WireGuard® is an extremely simple yet fast and modern VPN that utilizes **state-of-the-art** [cryptography](https://www.wireguard.com/protocol/). It aims to be [faster](https://www.wireguard.com/performance/), [simpler](https://www.wireguard.com/quickstart/), leaner, and more useful than IPsec, while avoiding the massive headache. It intends to be considerably more performant than OpenVPN. WireGuard is designed as a general purpose VPN for running on embedded interfaces and super computers alike, fit for many different circumstances. Initially released for the Linux kernel, it is now cross-platform (Windows, macOS, BSD, iOS, Android) and widely deployable. It is currently under heavy development, but already it might be regarded as the most secure, easiest to use, and simplest VPN solution in the industry.

The image uses the `wg` command as its entry-point.

## Usage

It is probably best if you don't use this "experimental" container image for anything sensitive. Experimental isn't exactly the right word because the Dockerfile just installs the recommended package and does nothing else, but using this image means you're trusting my setup, my github account, possibly my docker hub account in addition to the apk server, the apk packager's hardware and accounts, etc.

```
Usage: /usr/bin/wg <cmd> [<args>]

Available subcommands:
  show: Shows the current configuration and device information
  showconf: Shows the current configuration of a given WireGuard interface, for use with `setconf'
  set: Change the current configuration, add peers, remove peers, or change peers
  setconf: Applies a configuration file to a WireGuard interface
  addconf: Appends a configuration file to a WireGuard interface
  syncconf: Synchronizes a configuration file to a WireGuard interface
  genkey: Generates a new private key and writes it to stdout
  genpsk: Generates a new preshared key and writes it to stdout
  pubkey: Reads a private key from stdin and writes a public key to stdout
You may pass `--help' to any of these subcommands to view usage.
```

### Interactive

Here is a shell function that might help if you want to throw caution to the wind:

```sh

wireguard() {
  docker run \
    --rm \
    --interactive \
    --tty \
    "backplane/wireguard" \
    "$@"
}

```
