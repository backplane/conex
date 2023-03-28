# htpasswd

[`alpine`](https://hub.docker.com/_/alpine/)-based dockerization of [`apache2-utils`](https://pkgs.alpinelinux.org/package/edge/main/x86_64/apache2-utils) which provides [`htpasswd`](https://httpd.apache.org/docs/current/programs/htpasswd.html)

As the site says:

> htpasswd is used to create and update the flat-files used to store usernames and password for basic authentication of HTTP users. If htpasswd cannot access a file, such as not being able to write to the output file or not being able to read the file in order to update it, it returns an error status and makes no changes.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/htpasswd).

## Usage

### Help Text

The program emits the following help text when invoked with the `--help` argument:

```
Usage:
	htpasswd [-cimBdpsDv] [-C cost] passwordfile username
	htpasswd -b[cmBdpsDv] [-C cost] passwordfile username password

	htpasswd -n[imBdps] [-C cost] username
	htpasswd -nb[mBdps] [-C cost] username password
 -c  Create a new file.
 -n  Don't update file; display results on stdout.
 -b  Use the password from the command line rather than prompting for it.
 -i  Read password from stdin without verification (for script usage).
 -m  Force MD5 encryption of the password (default).
 -B  Force bcrypt encryption of the password (very secure).
 -C  Set the computing time used for the bcrypt algorithm
     (higher is more secure but slower, default: 5, valid: 4 to 17).
 -d  Force CRYPT encryption of the password (8 chars max, insecure).
 -s  Force SHA encryption of the password (insecure).
 -p  Do not encrypt the password (plaintext, insecure).
 -D  Delete the specified user.
 -v  Verify password for the specified user.
On other systems than Windows and NetWare the '-p' flag will probably not work.
The SHA algorithm does not use a salt and is less secure than the MD5 algorithm.
```

### Interactive

The following shell function can assist in running this image interactively:

```sh
docker run --rm --volume "$(pwd):/work" backplane/htpasswd -c -b -B .htpasswd testuser testpassword
```
