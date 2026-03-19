# ccwrapper

[`alpine:3.23`](https://hub.docker.com/_/alpine/)-based dockerization of [Claude Code](https://code.claude.com/docs/en/overview), the agentic coding tool

As the site says:

> Claude Code is an agentic coding tool that reads your codebase, edits files, runs commands, and integrates with your development tools. Available in your terminal, IDE, desktop app, and browser. ... [It] helps you build features, fix bugs, and automate development tasks.

## Repositories

| Repo         | URL                                                      |
| ------------ | -------------------------------------------------------- |
| Docker File  | <https://github.com/backplane/conex/tree/main/ccwrapper> |
| Docker Image | <https://hub.docker.com/r/backplane/ccwrapper>           |

## Included Utils

In addition to claude-code the following utils are included

| Package             | Commands              | Description                                                                      |
| ------------------- | --------------------- | -------------------------------------------------------------------------------- |
| cargo 1.94          | `cargo`               | The Rust package manager                                                         |
| curl 8.19           | `curl`; `wcurl`       | URL retrival utility and library                                                 |
| docker-cli 29.3     | `docker`              | Docker CLI (the plugin for `docker compose` is also included)                    |
| gcc 15.2            | `gcc`                 | The GNU Compiler Collection                                                      |
| git 2.53            | `git`                 | Distributed version control system                                               |
| go 1.26             | `go`; `gofmt`         | Go programming language compiler                                                 |
| gpg 2.4             | `gpg`                 | GNU Privacy Guard 2 - public key operations only                                 |
| jq 1.8              | `jq`                  | A lightweight and flexible command-line JSON processor                           |
| nodejs 24.14        | `node`                | JavaScript runtime built on V8 engine - LTS version                              |
| openssh-client 10.2 | `scp`; `sftp`; `ssh`  | OpenBSD's SSH client common files                                                |
| patch 2.8           | `patch`               | Utility to apply diffs to files                                                  |
| perl 5.42           | `perl`                | Larry Wall's Practical Extraction and Report Language                            |
| pnpm 10.32          | `pnpm`; `pnpx`        | Fast, disk space efficient package manager                                       |
| rage 0.11           | `rage`; `rage-keygen` | Simple, modern and secure encryption tool                                        |
| ripgrep 15.1        | `rg`                  | ripgrep combines the usability of The Silver Searcher with the raw speed of grep |
| rsync 3.4           | `rsync`; `rsync-ssl`  | A file transfer program to keep remote files in sync                             |
| rust 1.94           | `rustc`; `rustdoc`    | Rust Programming Language toolchain                                              |
| shellcheck 0.11     | `shellcheck`          | a static analysis tool for shell scripts                                         |
| ssl_client 1.37     | `ssl_client`          | External ssl_client for busybox wget                                             |
| uv 0.10             | `uv`; `uvx`           | Extremely fast Python package installer and resolver, written in Rust            |
| yq-go 4.52          | `yq`                  | Portable command-line YAML processor written in Go                               |
| zstd 1.5            | `unzstd`; `zstd`      | Zstandard - Fast real-time compression algorithm                                 |

## Usage

This image runs as the user nonroot (`65532:65532`), in the directory `/work`, with the entrypoint `claude`.

Mount points:

- `/work` - the current working directory, where the codebase should be mounted
- `/home/nonroot` - the directory where claude and related state lives

Example:

```sh
docker run -it --init --rm \
  --volume "$(pwd):/work:rw" \
  --volume "${HOME}/.ccwrapper/$(pwd | tr -C 'A-Za-z0-9\n' '_'):/home/nonroot:rw" \
  backplane/ccwrapper
```
