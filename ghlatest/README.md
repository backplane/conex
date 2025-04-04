# ghlatest

[`scratch`](https://hub.docker.com/_/scratch/)-based dockerization of [ghlatest](https://github.com/backplane/ghlatest), a release downloader utility

This container is a work-in-progress.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/ghlatest).

## Usage

This is the output of the container when invoked with the `-h` argument.

```
NAME:
   ghlatest - Release locator for software on github

USAGE:
   ghlatest [global options] command [command options] [arguments...]

VERSION:
   dev

COMMANDS:
   list, l, ls      list available releases
   download, d, dl  download the latest available release
   json, j          print json doc representing latest release from github api
   help, h          Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --help, -h     show help
   --version, -v  print the version
```
