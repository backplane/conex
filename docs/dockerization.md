## Dockerization Guidelines For This Repo

I aspire to these guidelines when dockerizing things _for this repo_ but for prod/critical apps things like version-pinning are required.

* Dockerfile instructions (e.g. `FROM`, `RUN`, `COPY`, `ENTRYPOINT`) should be in uppercase letters.
* Base images directly on well-maintained OS-distro images in the docker hub library like `alpine:edge`, `debian:stable-slim`, or in some cases `ubuntu`. Or use `scratch`.
* Always include a maintainer label
* Limit layers and layer sizes as much as possible with the general layer structure:
	1. OS-level package deps + cleanup (e.g. `apk add` or `apt install`)
	2. App-level package deps + cleanup (e.g. `pip install` or `npm install`). Try to add these via manifest files like `requirements.txt` or `package.json` to enable security scanning.
	3. App code (usually via `COPY` or `curl`) as near to the end of the file as possible
* Fetch via verified TLS. Verify gpg signatures and checksums.
* Drop privs when possible (with `RUN adduser ...` or equivalent then `USER`)
* For `RUN` instructions:

	* Start long instructions with `set -x`
	* Split complex commands across multiple lines using the continuation character `\`
	* Generally use one command per line...
	* ...but split complex commands so they have one argument per line
	* Things like package installs get one package per line, always indented one additional level, sorted alphabetically, ending with a sentinel like true if the package install is the last thing in the run command.
	* Put `&&` at the beginning of the line, not the end.
	
	For example:

	```
	RUN apk add --no-cache \
	    git \
	    make \
	  && true
	```
	
* For entrypoint scripts and other helpers: if you can't clearly and readably write it in POSIX-compliant shell script (i.e., `#!/bin/sh`) then use a real programming language. Do not use bash-isms and other half-measures.
* Lint and check everything (e.g., with tools like `shellcheck`, `pylint`, `go lint`, etc.)
* Use build args to parameterize things like version numbers in package downloads. If you do so, include an adjacent comment with the URL a human and use to check for updates / release notes.
* For contained services, follow the [12 factors](https://en.wikipedia.org/wiki/Twelve-Factor_App_methodology)
* Don't embed secrets in images, don't put secrets in environment variables
