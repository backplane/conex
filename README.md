# conex

This is a repository of source files for various utility [Docker](https://en.wikipedia.org/wiki/Docker_%28software%29) container images. The corresponding README file for each image usually has some information about how to use it. Feedback/contributions welcome. **Special thanks to the distro package maintainers who have volunteered to take on the responsibility of keeping their packages up to date!**

The image sources in this repo are automatically built at least once every 7 days and these <a href="https://hub.docker.com/r/backplane/conex/tags">scheduled builds are published to <img src="/.assets/dockerhub.png" width="150" height="28" alt="docker hub"></a>.

The name "conex" is a reference to the [Conex box](https://en.wikipedia.org/wiki/Intermodal_container), the key component of [containerization (in freight transport)](https://en.wikipedia.org/wiki/Containerization). Docker's creators make frequent use of the shipping container metaphor because the way that Docker standardizes (and thereby improves) the packaging, auditing, delivery, isolation, and use of *software* is analogous to the way the shipping container standardized (and thereby revolutionized) the packaging, tracking, isolation, and delivery of *freight*.

**LICENSE NOTE**: This repo contains code for installing and running 3rd party software packages in Docker containers. Unless otherwise noted the code in this repo is subject to the LICENSE file. The use of the generated images is subject to the terms of the respective software packages.

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

## Images

Name | Description | Dockerfile Link | Image Link
:--- | :---------- | :-------------- | :---------
[7z](7z) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [p7zip](https://www.7-zip.org/) | [Dockerfile](7z/Dockerfile) | [backplane/7z](https://hub.docker.com/r/backplane/7z)
[abe](abe) | [`amazoncorretto:16-alpine`](https://hub.docker.com/_/amazoncorretto/)-based dockerization of [android-backup-extractor](https://github.com/nelenkov/android-backup-extractor), a "utility to extract and repack Android backups created with adb backup" | [Dockerfile](abe/Dockerfile) | [backplane/abe](https://hub.docker.com/r/backplane/abe)
[adb](adb) | [`debian:stable-slim`](https://hub.docker.com/_/debian/)-based dockerization of the [Android Debug Bridge](https://developer.android.com/studio/command-line/adb) | [Dockerfile](adb/Dockerfile) | [backplane/adb](https://hub.docker.com/r/backplane/adb)
[apg](apg) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of apg -- the "Automated Password Generator" | [Dockerfile](apg/Dockerfile) | [backplane/apg](https://hub.docker.com/r/backplane/apg)
[audiosprite](audiosprite) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [audiosprite](https://github.com/tonistiigi/audiosprite), the "ffmpeg wrapper that will take in multiple audio files and combines them into a single file" | [Dockerfile](audiosprite/Dockerfile) | [backplane/audiosprite](https://hub.docker.com/r/backplane/audiosprite)
[black](black) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [black](https://black.readthedocs.io/en/stable/), the python code formatter | [Dockerfile](black/Dockerfile) | [backplane/black](https://hub.docker.com/r/backplane/black)
[blampy](blampy) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerized melange of Python dev tools, including [black](https://black.readthedocs.io/en/stable/) (the python code formatter), [bpython](https://bpython-interpreter.org/) (the enhanced python REPL), [mypy](https://github.com/python/mypy) (the Python type checker), [pycodestyle](https://pycodestyle.pycqa.org/) (the code linter), and [pylint](https://www.pylint.org/) (the error checker). | [Dockerfile](blampy/Dockerfile) | [backplane/blampy](https://hub.docker.com/r/backplane/blampy)
[bpython](bpython) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [the bpython interpreter](https://bpython-interpreter.org/) | [Dockerfile](bpython/Dockerfile) | [backplane/bpython](https://hub.docker.com/r/backplane/bpython)
[chardet](chardet) | [`python:3-alpine`](https://hub.docker.com/_/python/)-based dockerization of [chardet](https://github.com/chardet/chardet), The Universal Character Encoding Detector | [Dockerfile](chardet/Dockerfile) | [backplane/chardet](https://hub.docker.com/r/backplane/chardet)
[checkmake](checkmake) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [checkmake](https://github.com/mrtazz/checkmake/), the `Makefile` linter | [Dockerfile](checkmake/Dockerfile) | [backplane/checkmake](https://hub.docker.com/r/backplane/checkmake)
[chrome](chrome) | [`debian:unstable-slim`](https://hub.docker.com/_/debian/)-based dockerization of the Google Chrome web browser | [Dockerfile](chrome/Dockerfile) | [backplane/chrome](https://hub.docker.com/r/backplane/chrome)
[compose_sort](compose_sort) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of `compose_sort`, a CLI utility for sorting docker-compose files | [Dockerfile](compose_sort/Dockerfile) | [backplane/compose_sort](https://hub.docker.com/r/backplane/compose_sort)
[firefox](firefox) | [`debian:unstable-slim`](https://hub.docker.com/_/debian/)-based dockerization of the Firefox web browser | [Dockerfile](firefox/Dockerfile) | [backplane/firefox](https://hub.docker.com/r/backplane/firefox)
[fzf](fzf) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [fzf](https://github.com/junegunn/fzf) the command line fuzzy finder | [Dockerfile](fzf/Dockerfile) | [backplane/fzf](https://hub.docker.com/r/backplane/fzf)
[ghlatest](ghlatest) | scratch-based dockerization of [ghlatest](https://github.com/glvnst/ghlatest), a release downloader utility | [Dockerfile](ghlatest/Dockerfile) | [backplane/ghlatest](https://hub.docker.com/r/backplane/ghlatest)
[goenv](goenv) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of the [go](https://golang.org/) programming language compiler and tools | [Dockerfile](goenv/Dockerfile) | [backplane/goenv](https://hub.docker.com/r/backplane/goenv)
[graphviz](graphviz) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [graphviz](https://graphviz.gitlab.io/), the graph visualization software | [Dockerfile](graphviz/Dockerfile) | [backplane/graphviz](https://hub.docker.com/r/backplane/graphviz)
[grta](grta) | [`scratch`](https://hub.docker.com/_/scratch/)-based single-binary container image which provides an HTTP endpoint which receives webhooks and writes the PSK-validated payloads to disk | [Dockerfile](grta/Dockerfile) | [backplane/grta](https://hub.docker.com/r/backplane/grta)
[haskellenv](haskellenv) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of the [Glasgow Haskell Compiler](https://www.haskell.org/ghc/) and [Cabal](https://www.haskell.org/cabal/) | [Dockerfile](haskellenv/Dockerfile) | [backplane/haskellenv](https://hub.docker.com/r/backplane/haskellenv)
[httpie](httpie) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [HTTPie](https://httpie.org/) the versatile command line HTTP client | [Dockerfile](httpie/Dockerfile) | [backplane/httpie](https://hub.docker.com/r/backplane/httpie)
[hugo](hugo) | [`debian:stable-slim`](https://hub.docker.com/_/debian/)-based dockerization of hugo-extended -- the static site generator | [Dockerfile](hugo/Dockerfile) | [backplane/hugo](https://hub.docker.com/r/backplane/hugo)
[jq](jq) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [jq](https://stedolan.github.io/jq/) | [Dockerfile](jq/Dockerfile) | [backplane/jq](https://hub.docker.com/r/backplane/jq)
[json-server](json-server) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [json-server](https://github.com/typicode/json-server) | [Dockerfile](json-server/Dockerfile) | [backplane/json-server](https://hub.docker.com/r/backplane/json-server)
[kp1p](kp1p) | [`python:3-alpine`](https://hub.docker.com/_/python/)-based dockerization of kp1p, a utility for translating csv files exported from KeePassX/KeePassXC into a csv format that is better supported by 1Password. | [Dockerfile](kp1p/Dockerfile) | [backplane/kp1p](https://hub.docker.com/r/backplane/kp1p)
[lxde](lxde) | [`debian:stable-slim`](https://hub.docker.com/_/debian/)-based dockerization of [TigerVNC](https://tigervnc.org/) running an [LXDE](https://lxde.org/) X11 desktop environment | [Dockerfile](lxde/Dockerfile) | [backplane/lxde](https://hub.docker.com/r/backplane/lxde)
[mssql-cli](mssql-cli) | [`debian:stretch-slim`](https://hub.docker.com/_/debian/)-based dockerization of [mssql-cli](https://github.com/dbcli/mssql-cli) (part of the [DBCLI](https://www.dbcli.com/) project) | [Dockerfile](mssql-cli/Dockerfile) | [backplane/mssql-cli](https://hub.docker.com/r/backplane/mssql-cli)
[mssql-scripter](mssql-scripter) | [`debian:buster-slim`](https://hub.docker.com/_/debian/)-based dockerization of [mssql-scripter](https://github.com/microsoft/mssql-scripter), a multi-platform command line experience for scripting SQL Server databases. | [Dockerfile](mssql-scripter/Dockerfile) | [backplane/mssql-scripter](https://hub.docker.com/r/backplane/mssql-scripter)
[myip](myip) | [`scratch`](https://hub.docker.com/_/scratch/)-based single-binary container image which provides an HTTP endpoint which returns the user's own IP address in JSON format | [Dockerfile](myip/Dockerfile) | [backplane/myip](https://hub.docker.com/r/backplane/myip)
[mypy](mypy) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [mypy](https://github.com/python/mypy), the "optional static type checker for Python" | [Dockerfile](mypy/Dockerfile) | [backplane/mypy](https://hub.docker.com/r/backplane/mypy)
[ods_conv](ods_conv) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of a [Python](https://en.wikipedia.org/wiki/Python_(programming_language)) utility that converts ODS documents into other formats (currently JSON and CSV). [ODS document format](https://en.wikipedia.org/wiki/OpenDocument) support is provided by [pyexcel-ods3](https://github.com/pyexcel/pyexcel-ods3). | [Dockerfile](ods_conv/Dockerfile) | [backplane/ods_conv](https://hub.docker.com/r/backplane/ods_conv)
[pdf](pdf) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [poppler-utils](https://pkgs.alpinelinux.org/package/edge/main/x86_64/poppler-utils) with a thin wrapper. | [Dockerfile](pdf/Dockerfile) | [backplane/pdf](https://hub.docker.com/r/backplane/pdf)
[pwgen](pwgen) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [pwgen](https://github.com/tytso/pwgen) -- the password generator written by [Theodore Ts'o](https://github.com/tytso) | [Dockerfile](pwgen/Dockerfile) | [backplane/pwgen](https://hub.docker.com/r/backplane/pwgen)
[pycodestyle](pycodestyle) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [pycodestyle](https://pycodestyle.pycqa.org/), the python linter | [Dockerfile](pycodestyle/Dockerfile) | [backplane/pycodestyle](https://hub.docker.com/r/backplane/pycodestyle)
[pygmentize](pygmentize) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of the [pygmentize](https://pygments.org/docs/cmdline/) utility from the [Pygments](https://pygments.org/) generic syntax highlighter package | [Dockerfile](pygmentize/Dockerfile) | [backplane/pygmentize](https://hub.docker.com/r/backplane/pygmentize)
[pylint](pylint) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [pylint](https://www.pylint.org/) | [Dockerfile](pylint/Dockerfile) | [backplane/pylint](https://hub.docker.com/r/backplane/pylint)
[qrencode](qrencode) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [qrencode](https://fukuchi.org/works/qrencode/), the command-line utility for generating QR codes in various formats (PNG, terminal text, etc.) | [Dockerfile](qrencode/Dockerfile) | [backplane/qrencode](https://hub.docker.com/r/backplane/qrencode)
[shunit2](shunit2) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [shUnit2](https://github.com/kward/shunit2/), the "xUnit-based unit test framework for Bourne-based shell scripts." | [Dockerfile](shunit2/Dockerfile) | [backplane/shunit2](https://hub.docker.com/r/backplane/shunit2)
[snakeeyes](snakeeyes) | [`scratch`](https://hub.docker.com/_/scratch/)-based single-binary container image featuring [snakeeyes](https://github.com/glvnst/snakeeyes), the command-line passphrase generator | [Dockerfile](snakeeyes/Dockerfile) | [backplane/snakeeyes](https://hub.docker.com/r/backplane/snakeeyes)
[sql-formatter](sql-formatter) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [sql-formatter](https://github.com/zeroturnaround/sql-formatter) the util for formatting SQL queries | [Dockerfile](sql-formatter/Dockerfile) | [backplane/sql-formatter](https://hub.docker.com/r/backplane/sql-formatter)
[tsqllint](tsqllint) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [TSQLLint](https://github.com/tsqllint/tsqllint) the util for listing mssql code | [Dockerfile](tsqllint/Dockerfile) | [backplane/tsqllint](https://hub.docker.com/r/backplane/tsqllint)
[vueenv](vueenv) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based image for working with [Vue.js](https://vuejs.org/); meant to be run interactively during development and also used as a builder stage for [Vue CLI](https://cli.vuejs.org/)-based apps in a multi-stage image build | [Dockerfile](vueenv/Dockerfile) | [backplane/vueenv](https://hub.docker.com/r/backplane/vueenv)
[wimlib-imagex](wimlib-imagex) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of the [`wimlib-imagex`](https://wimlib.net/man1/wimlib-imagex.html) utility from [the open source Windows Imaging (WIM) library](https://wimlib.net/) | [Dockerfile](wimlib-imagex/Dockerfile) | [backplane/wimlib-imagex](https://hub.docker.com/r/backplane/wimlib-imagex)
[wireguard](wireguard) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [WireGuard](https://www.wireguard.com/), the free open-source VPN software | [Dockerfile](wireguard/Dockerfile) | [backplane/wireguard](https://hub.docker.com/r/backplane/wireguard)
[wpa_passphrase](wpa_passphrase) | [`scratch`](https://hub.docker.com/_/scratch/)-based container image which contains the `wpa_passphrase` utility from [Jouni Malinen's wpa_supplicant package](https://w1.fi/wpa_supplicant) | [Dockerfile](wpa_passphrase/Dockerfile) | [backplane/wpa_passphrase](https://hub.docker.com/r/backplane/wpa_passphrase)
[youtube-dl](youtube-dl) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [youtube-dl](https://ytdl-org.github.io/youtube-dl/), the command-line media download utility with support for [about 1000 sites](https://ytdl-org.github.io/youtube-dl/supportedsites.html) | [Dockerfile](youtube-dl/Dockerfile) | [backplane/youtube-dl](https://hub.docker.com/r/backplane/youtube-dl)
