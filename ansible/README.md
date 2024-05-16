# ansible

[`python:3-alpine`](https://hub.docker.com/_/python/)-based dockerization of [ansible](https://www.ansible.com/), [ansible-runner](https://ansible-runner.readthedocs.io), and [molecule](https://ansible.readthedocs.io/projects/molecule/)

As the [wikipedia article](https://en.wikipedia.org/wiki/Ansible_(software)) says:

> Ansible is an open-source software provisioning, configuration management, and application-deployment tool enabling infrastructure as code.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/ansible).

## Usage

The following tools are available in the container:

* `ansible`
* `ansible-community`
* `ansible-config`
* `ansible-connection`
* `ansible-console`
* `ansible-doc`
* `ansible-galaxy`
* `ansible-inventory`
* `ansible-playbook`
* `ansible-pull`
* `ansible-runner`
* `ansible-test`
* `ansible-vault`
* `molecule`

These can be invoked as commands to the container, for example:

```sh
docker run --rm -it --volume "$(pwd):/work" backplane/ansible ansible-config -h
```
