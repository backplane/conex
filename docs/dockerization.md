## Dockerization Guidelines

I aspire to the following guidelines when packaging things _for this repo_ with production and/or critical software, some additional steps like version-pinning and health checks are highly recommended.

* `Dockerfile` instructions (e.g.; `FROM`, `RUN`, `COPY`, `ENTRYPOINT`) should be in UPPERCASE letters.
* For the `FROM` instruction:
	* Use `scratch` if possible
	* If the software vendor has created an official image and it is well-designed and well-maintained, it can be used as a base 
	* Otherwise use well-maintained OS distributions from the [docker hub "library"](https://hub.docker.com/u/library/) (see also: [docker hub "official" repos](https://docs.docker.com/docker-hub/official_repos/)):
		*  [`alpine`](https://hub.docker.com/_/alpine) (preferred)
		*  [`debian`](https://hub.docker.com/_/debian) (prefer the `-slim` variants)
		*  in rare cases [`ubuntu`](https://hub.docker.com/_/ubuntu)
	* Avoid third-party base images as much as possible
* Always include a `maintainer` label
* Limit layers and layer sizes as much as possible with the general layer structure:
	1. OS-level package dependencies + cleanup (e.g. `apk add` or `apt install`)
	2. App-level package dependencies + cleanup (e.g., `pip install` or `npm install`). Try to add these via manifest files like `requirements.txt` or `package.json` to enable security scanning.
	3. App code (usually via `COPY` or `curl`) as near to the end of the file as possible
* Fetch via verified TLS. Verify gpg signatures and checksums as much as possible.
* Drop privileges when possible (with `RUN adduser ...` or equivalent then `USER`)
* For `RUN` instructions:

	* Start long instructions with `set -x`
	* Split complex commands across multiple lines using the continuation character `\`
	* Generally use one command per line...
	* ...but split complex commands so they have one argument group per line
	* Things like package installs get one package per line, always indented one additional level, sorted alphabetically, ending with a sentinel like `true` if the package install is the last thing in the run command.
	* Put `&&` at the beginning of the line, not the end.
	
	For example:

	```
	RUN apk add --no-cache \
	    git \
	    make \
	  && true
	```
	
* For entrypoint scripts and other helpers: if you can't clearly and readably write it in POSIX-compliant shell script (`#!/bin/sh`) then use a real programming language instead. Do not use bash-isms. See [shellhaters.org's helpful links](https://shellhaters.org/), [Bruce Barnett's POSIX Shell tutorial (part of "The Grymoire")](https://www.grymoire.com/Unix/Sh.html), and [Rich's POSIX shell tricks](https://www.etalabs.net/sh_tricks.html) for useful POSIX shell help.
* Lint and check everything (e.g., with tools like `shellcheck`, `pylint`, `go lint`, etc.)
* Use build args to parameterize things like version numbers in package downloads. If you do so, include an adjacent comment with the URL a human and use to check for updates / release notes.
* For contained services, follow the [12 factors](https://en.wikipedia.org/wiki/Twelve-Factor_App_methodology)
* Don't embed secrets in images, don't put secrets in environment variables
