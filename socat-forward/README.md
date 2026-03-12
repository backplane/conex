# socat-forward

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [socat](http://www.dest-unreach.org/socat), the "multipurpose relay (SOcket CAT)"

As the socat man-page says:

> Socat is a command line based utility that establishes two bidirectional byte streams and transfers data between them. Because the streams can be constructed from a large set of different types of data sinks and sources (see address types), and because lots of address options may be applied to the streams, socat can be used for many different purposes.

**NOTE:** This container uses an opinionated entrypoint designed for a specific limited purpose, which doesn't expose the full power of the socat utility. (You can override the docker entrypoint entirely if you just want to use socat in an alpine container.)

Normal execution involves:

`exec socat "$RX" "$TX"`

where:

```sh
RX="TCP4-LISTEN:${LISTEN_PORT},reuseaddr,fork${RX_ADDENDUM}"
TX="TCP4:${DEST_HOST}:${DEST_PORT}${TX_ADDENDUM}"
```

## Repositories

| Repo         | URL                                                          |
| ------------ | ------------------------------------------------------------ |
| Docker File  | <https://github.com/backplane/conex/tree/main/socat-forward> |
| Docker Image | <https://hub.docker.com/r/backplane/socat-forward>           |


## Usage

The program can be configured by the following environment variables or the corresponding cli arguments.

| ENVVAR        | Description                                   | Default |
| ------------- | --------------------------------------------- | ------- |
| `LISTEN_PORT` | network port to listen for connections on     | `443`   |
| `DEST_PORT`   | network port to send connections to           | `443`   |
| `DEST_HOST`   | network host to send connections to           | `dest`  |
| `RX_ADDENDUM` | string to append to listen TCP4-LISTEN clause | `""`    |
| `TX_ADDENDUM` | string to append to TCP4 clause               | `""`    |
| `RX_OVERRIDE` | argument to replace normal TCP4-LISTEN clause | `""`    |
| `TX_OVERRIDE` | argument to replace normal TCP4 clause        | `""`    |

The program emits the following help text when invoked with `-h` or `--help` flags.

```
Usage: entrypoint [-h|--help] [-d|--debug] [OPTION [...]]

FLAGS:
-h / --help        show this message
-d / --debug       print additional debugging messages

OPTIONS (respective envvar names appear below in UPPER_CASE):
--listen-port LISTEN_PORT  network port to listen for connections on
--dest-host DEST_HOST      network host to send connections to
--dest-port DEST_PORT      network port to send connections to
--rx-addendum RX_ADDENDUM  string to append to listen TCP4-LISTEN clause
--tx-addendum TX_ADDENDUM  string to append to TCP4 clause
--rx-override RX_OVERRIDE  argument to replace normal TCP4-LISTEN clause
--tx-override TX_OVERRIDE  argument to replace normal TCP4 clause

Runs socat configured (by default) to listen for IPv4 connections and
forward them to a given IPv4 destination
```

An example docker compose configuration:

```yaml
services:
  socat:
    image: backplane/socat-forward
    restart: unless-stopped
    environment:
      LISTEN_PORT: 8000
      DEST_HOST: 10.0.0.1
      DEST_PORT: 80
```

In some cases you'd want to add networks, ports, and/or labels for something like traefik.

## Log Output

The container logs its configuration at startup:

```
2026-03-12T09:56:05+0000 entrypoint starting as 65532 in /work with config:
2026-03-12T09:56:05+0000 entrypoint   LISTEN_PORT: "443"
2026-03-12T09:56:05+0000 entrypoint   DEST_PORT: "443"
2026-03-12T09:56:05+0000 entrypoint   DEST_HOST: "dest"
2026-03-12T09:56:05+0000 entrypoint   RX_ADDENDUM: ""
2026-03-12T09:56:05+0000 entrypoint   TX_ADDENDUM: ""
2026-03-12T09:56:05+0000 entrypoint   RX_OVERRIDE: ""
2026-03-12T09:56:05+0000 entrypoint   TX_OVERRIDE: ""
2026-03-12T09:56:05+0000 entrypoint computed config:
2026-03-12T09:56:05+0000 entrypoint   RX: TCP4-LISTEN:443,reuseaddr,fork
2026-03-12T09:56:05+0000 entrypoint   TX: TCP4:dest:443
```
