# ansible-runner

[`python:3-alpine`](https://hub.docker.com/_/alpine/)-based dockerization of [ansible-runner](https://ansible-runner.readthedocs.io).


As the site says:

> Runner is intended to be most useful as part of automation and tooling that needs to invoke Ansible and consume its results

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

ansible_runner() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/ansible-runner" \
    "$@"
}

```
