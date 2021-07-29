# mssql-cli

[`debian:stretch-slim`](https://hub.docker.com/_/debian/)-based dockerization of [mssql-cli](https://github.com/dbcli/mssql-cli) (part of the [DBCLI](https://www.dbcli.com/) project)

As the site says, `mssql-cli` is:

> A command-line client for SQL Server with auto-completion and syntax highlighting 

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

mssqlcli() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/mssql-cli" \
    "$@"
}

```
