# wireproxy

This is a a [scratch](https://hub.docker.com/_/scratch/)-based dockerization of [wireproxy](https://github.com/whyvl/wireproxy), the "wireguard client that exposes itself as a socks5 proxy."

As [the site](https://github.com/whyvl/wireproxy) says:

> wireproxy is a completely userspace application that connects to a wireguard peer, and exposes a socks5/http proxy or tunnels on the machine. This can be useful if you need to connect to certain sites via a wireguard peer, but can't be bothered to setup a new network interface for whatever reasons.

This image is built from the latest semantic version tag in the wireproxy repo and uses scratch instead of distroless.

Note: The [wireproxy GitHub repo](https://github.com/whyvl/wireproxy) already has an excellent [Dockerfile](https://github.com/whyvl/wireproxy/blob/master/Dockerfile) with [official wireproxy images on GHCR](https://github.com/whyvl/wireproxy/pkgs/container/wireproxy). 

For usage information, see the [wireproxy](https://github.com/whyvl/wireproxy) repo.