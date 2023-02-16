# true

[`scratch`](https://hub.docker.com/_/scratch/)-based single-binary no-op container that always exits successfully

This container does nothing except exit with exitcode 0. It is useful for testing container infrastructure.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/true).

## Usage

```sh
docker run --rm backplane/true
```
