# htpasswd

[`alpine`](https://hub.docker.com/_/alpine/)-based dockerization of [apache2-utils](https://pkgs.alpinelinux.org/package/edge/main/x86_64/apache2-utils) which provides [`htpasswd`](https://httpd.apache.org/docs/current/programs/htpasswd.html)

As the site says:

> htpasswd is used to create and update the flat-files used to store usernames and password for basic authentication of HTTP users. If htpasswd cannot access a file, such as not being able to write to the output file or not being able to read the file in order to update it, it returns an error status and makes no changes.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/htpasswd).

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh
docker run --rm --volume "$(pwd):/work" backplane/htpasswd -c -b -B .htpasswd testuser testpassword
```
