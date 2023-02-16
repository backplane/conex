# bind

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [bind](https://www.isc.org/bind/), the DNS server software

As the site says:

> BIND 9 has evolved to be a very flexible, full-featured DNS system. Whatever your application is, BIND 9 probably has the required features. As the first, oldest, and most commonly deployed solution, there are more network engineers who are already familiar with BIND 9 than with any other system.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/bind).

## Usage

This container image is meant to provide a very simple authoritative name server for temporary or LAN use. It is not optimized for production use on the public internet.

To use it, just mount your zone files into `/config/zones/` and the container will serve them authoritatively (zone files should appear with the exact name of the zone; e.g. for the zone `example.com`, the file would be mounted at `/config/zones/example.com`; and PTR records aka "reverse dns" for `192.168.0` would be mounted at `/config/zones/0.168.192.in-addr.arpa`).

This works because at startup the contents of `/config` get copied to `/etc/bind`.

If you want more complex config, you can put a `named.conf` in `/config/named.conf`. If the string `include "/etc/bind/zones.conf";` is found in the `named.conf`, a `zones.conf` file will be built containing primary references to the files found in the zones subdirectory (meaning you can add and remove zones without having to think about adjusting the `named.conf` file.

### Default `named.conf`

Here you can see the default `named.conf` that is included with this container image:

```
// online man pages:
// https://bind9.readthedocs.io/
// http://linux.die.net/man/5/named.conf
// http://linux.die.net/man/8/named

options {
    directory "/etc/bind/";
    pid-file "/var/run/named/named.pid";

    allow-query { any; };
    allow-query-cache { none; };
    allow-recursion { none; };
    allow-transfer { none; };
    dnssec-enable no;
    listen-on { any; };
    listen-on-v6 { none; };
    notify no;
    recursion no;
};
controls {};
include "/etc/bind/zones.conf";
```

### Example

The following run command demonstrates how the container might be used:

```sh
docker run \
  --detach \
  --tty \
  --publish "53:53/udp" \
  --publish "53:53/tcp"
  --volume "$(pwd)/zones:/config/zones" \
  "backplane/bind"
```