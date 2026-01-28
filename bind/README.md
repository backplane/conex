# bind

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [bind](https://www.isc.org/bind/), the DNS server software

As the site says:

> BIND 9 has evolved to be a very flexible, full-featured DNS system. Whatever your application is, BIND 9 probably has the required features. As the first, oldest, and most commonly deployed solution, there are more network engineers who are already familiar with BIND 9 than with any other system.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/bind).

## Usage

This container image is meant to provide a very simple authoritative name server for temporary or LAN use. It is not optimized for production use on the public internet.

To use it, just mount your zone files into `/config/zones/` and the container will serve them authoritatively (zone files should appear with the exact name of the zone; e.g. for the zone `example.com`, the file would be mounted at `/config/zones/example.com`; and PTR records aka "reverse dns" for `192.168.0` would be mounted at `/config/zones/0.168.192.in-addr.arpa`).

This works because at startup the contents of `/config` get copied to `/etc/bind` and any zone files found in `/etc/bind/zones` are automatically added to a container-generated file `/etc/bind/zones.conf`

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
    listen-on { any; };
    listen-on-v6 { none; };
    notify no;
    recursion no;
    trust-anchor-telemetry no;
};
controls {};
include "/etc/bind/zones.conf";
```

### Example

The following run command demonstrates how the container might be used:

```bash
docker run \
  --detach \
  --tty \
  --publish "53:53/udp" \
  --publish "53:53/tcp" \
  --volume "$(pwd)/zones:/config/zones" \
  "backplane/bind"
```

## Entry Point Configuration

The container entry point is configured by environment variables which can be overridden by command-line arguments. The following table documents the options and their meaning.

| Command-line Argument | Environment Variable | Description                                                                     | Default                |
| --------------------- | -------------------- | ------------------------------------------------------------------------------- | ---------------------- |
| `--bind-dir`          | `BIND_DIR`           | path of the bind configuration directory                                        | `/etc/bind`            |
| `--bind-config`       | `BIND_CONFIG`        | full path of the `named.conf` bind config file                                  | `/etc/bind/named.conf` |
| `--zone-dir`          | `ZONE_DIR`           | path of a directory containing (only) zone files to automatically serve         | `/etc/bind/zones`      |
| `--zone-config`       | `ZONE_CONFIG`        | full path of the `zones.conf` file to generate from the files found in ZONE_DIR | `/etc/bind/zones.conf` |
| `--config-dir`        | `CONFIG_DIR`         | path of a directory whose contents could be copied into the BIND_DIR            | `/config`              |

### Entry Point Usage

The entrypoint emits the following help text when started with the `-h` or `--help` command-line arguments:

```
Usage: entrypoint [-h|--help] [arg [...]]

-h / --help   show this message
-d / --debug  print additional debugging messages

--bind-dir BIND_DIR        path of the bind configuration directory
                           (default: '/etc/bind')
--bind-config BIND_CONFIG  full path of the 'named.conf' bind config file
                           (default: '/etc/bind/named.conf')
--zone-dir ZONE_DIR        path of a directory containing (only) zone
                           files to automatically serve
                           (default: '/etc/bind/zones')
--zone-config ZONE_CONFIG  full path of the 'zones.conf' file to generate
                           from the files found in ZONE_DIR
                           (default: '/etc/bind/zones.conf')
--config-dir CONFIG_DIR    path of a directory whose contents could be
                           copied into the BIND_DIR
                           (default: '/config')

--                         Pass the remaining command-line arguments to
                           bind directly

Generates a zones.conf file which 'includes' all the zone files found in
the ZONE_DIR, runs named-checkconf, then starts bind
```
