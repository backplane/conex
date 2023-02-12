# proxyport

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based sidecar container for forwarding ports to remote hosts

As the site says:

> HAProxy is a free, very fast and reliable reverse-proxy offering high availability, load balancing, and proxying for TCP and HTTP-based applications

This container is **NOT** a general-purpose containerization of haproxy, it is using haproxy exclusively the single specific purpose of forwaring ports in a container sidecar context.

The image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/proxyport).

## Usage

This is text of the entrypoint's usage function:

```
Usage: entrypoint [-h|--help] [arg [...]]

-h / --help   show this message
-d / --debug  print additional debugging messages

allow:<ip_cidr>    add an ACL allow entry for the given IP subnet
deny:<ip_cidr>     add an ACL deny entry for the given IP subnet
proxy:<listen_port>:<upstream_host>:<upstream_port>
                   add a frontend and backend pair that proxies
                   connections to the given port to the the given
                   upstream host and port

This container proxies HTTP connections to remote hosts.


```

### Interactive

The following shell function can assist in running this image interactively:

```sh

proxyport() {
  docker run \
    --rm \
    "backplane/proxyport" \
    "$@"
}

```
