# ansible

[`alpine:3`](https://hub.docker.com/_/alpine/)-based dockerization of [ansible](https://www.ansible.com/) and [ansible-runner](https://ansible-runner.readthedocs.io)

As the [wikipedia article](https://en.wikipedia.org/wiki/Ansible_(software)) says:

> Ansible is an open-source software provisioning, configuration management, and application-deployment tool enabling infrastructure as code.

The image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/ansible).

## Usage

This is the help text provided by the container's entrypoint:

```
Note: this is the help text for an ansible container entrypoint, if you
      want to see the help text for ansible itself, use something like:
      docker run --rm -it backplane/ansible ansible -h


Usage: entrypoint [-h|--help] <utility> [arg [...]]

-h / --help   show this message
-d / --debug  print additional debugging messages
<utility>     run the named ansible utility with any given arguments
              must be one of the following:
                ansible
                ansible-config
                ansible-connection
                ansible-console
                ansible-doc
                ansible-galaxy
                ansible-inventory
                ansible-playbook
                ansible-pull
                ansible-runner
                ansible-test
                ansible-vault

If no utility is specified, 'ansible' will be used.
```

### Interactive

The following shell function can assist in running this image interactively:

```sh

ansible() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/ansible" \
    "$@"
}

```
