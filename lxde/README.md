## `lxde`

### Usage

This is a debian:stable-slim -based dockerization of [TigerVNC](https://tigervnc.org/) running an [LXDE](https://lxde.org/) X11 desktop.

Start the container below. The session-specific VNC password will be printed to the standard output. Then VNC to localhost and enter the password.

`sudo` is available but you need to set a password for the non-priv user first.

I'm more interested in deploying this in a pod with [noVNC](https://novnc.com/info.html) behind TLS.

#### Interactive

```sh

lxde() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --publish "5900:5900" \
    --volume "lxdehome:/work/" \
    "galvanist/conex:lxde" \
    "$@"
}

```
