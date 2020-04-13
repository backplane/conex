# conex

This is a repository of source files for various utility docker images. The corresponding README file for each image usually has some information on how to use it. Feedback/contributions welcome.

The image sources in this repo have weekly <a href="https://hub.docker.com/r/galvanist/conex/tags">scheduled builds published to <img src="/.assets/dockerhub.png" width="150" height="28" alt="docker hub"></a>

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

## Images

Name | Description | Dockerfile Link | Image Link
:--- | :---------- | :-------------- | :---------
[adb](adb) | [`debian:stable-slim`](https://hub.docker.com/_/debian/)-based dockerization of the [Android Debug Bridge](https://developer.android.com/studio/command-line/adb) | [Dockerfile](adb/Dockerfile) | [galvanist/conex:adb](https://hub.docker.com/r/galvanist/conex/tags?name=adb)
[apg](apg) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of apg -- the "Automated Password Generator" | [Dockerfile](apg/Dockerfile) | [galvanist/conex:apg](https://hub.docker.com/r/galvanist/conex/tags?name=apg)
[audiosprite](audiosprite) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [audiosprite](https://github.com/tonistiigi/audiosprite), the "ffmpeg wrapper that will take in multiple audio files and combines them into a single file" | [Dockerfile](audiosprite/Dockerfile) | [galvanist/conex:audiosprite](https://hub.docker.com/r/galvanist/conex/tags?name=audiosprite)
[bpython](bpython) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [the bpython interpreter](https://bpython-interpreter.org/) | [Dockerfile](bpython/Dockerfile) | [galvanist/conex:bpython](https://hub.docker.com/r/galvanist/conex/tags?name=bpython)
[checkmake](checkmake) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [checkmake](https://github.com/mrtazz/checkmake/), the `Makefile` linter | [Dockerfile](checkmake/Dockerfile) | [galvanist/conex:checkmake](https://hub.docker.com/r/galvanist/conex/tags?name=checkmake)
[fzf](fzf) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [fzf](https://github.com/junegunn/fzf) the command line fuzzy finder | [Dockerfile](fzf/Dockerfile) | [galvanist/conex:fzf](https://hub.docker.com/r/galvanist/conex/tags?name=fzf)
[goenv](goenv) | [`debian:stable-slim`](https://hub.docker.com/_/debian/)-based dockerization of the [go](https://golang.org/) programming language compiler and tools | [Dockerfile](goenv/Dockerfile) | [galvanist/conex:goenv](https://hub.docker.com/r/galvanist/conex/tags?name=goenv)
[grta](grta) | [`scratch`](https://hub.docker.com/_/scratch/)-based single-binary container image which provides an HTTP endpoint which receives webhooks and writes the PSK-validated payloads to disk | [Dockerfile](grta/Dockerfile) | [galvanist/conex:grta](https://hub.docker.com/r/galvanist/conex/tags?name=grta)
[httpie](httpie) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [HTTPie](https://httpie.org/) the versatile command line HTTP client | [Dockerfile](httpie/Dockerfile) | [galvanist/conex:httpie](https://hub.docker.com/r/galvanist/conex/tags?name=httpie)
[hugo](hugo) | [`debian:stable-slim`](https://hub.docker.com/_/debian/)-based dockerization of hugo-extended -- the static site generator | [Dockerfile](hugo/Dockerfile) | [galvanist/conex:hugo](https://hub.docker.com/r/galvanist/conex/tags?name=hugo)
[jq](jq) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [jq](https://stedolan.github.io/jq/) | [Dockerfile](jq/Dockerfile) | [galvanist/conex:jq](https://hub.docker.com/r/galvanist/conex/tags?name=jq)
[json-server](json-server) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [json-server](https://github.com/typicode/json-server) | [Dockerfile](json-server/Dockerfile) | [galvanist/conex:json-server](https://hub.docker.com/r/galvanist/conex/tags?name=json-server)
[kotlinc](kotlinc) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of the kotlin compiler | [Dockerfile](kotlinc/Dockerfile) | [galvanist/conex:kotlinc](https://hub.docker.com/r/galvanist/conex/tags?name=kotlinc)
[lxde](lxde) | [`debian:stable-slim`](https://hub.docker.com/_/debian/)-based dockerization of [TigerVNC](https://tigervnc.org/) running an [LXDE](https://lxde.org/) X11 desktop environment | [Dockerfile](lxde/Dockerfile) | [galvanist/conex:lxde](https://hub.docker.com/r/galvanist/conex/tags?name=lxde)
[myip](myip) | [`scratch`](https://hub.docker.com/_/scratch/)-based single-binary container image which provides an HTTP endpoint which returns the user's own IP address in JSON format | [Dockerfile](myip/Dockerfile) | [galvanist/conex:myip](https://hub.docker.com/r/galvanist/conex/tags?name=myip)
[pwgen](pwgen) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [pwgen](https://github.com/tytso/pwgen) -- the password generator written by [Theodore Ts'o](https://github.com/tytso) | [Dockerfile](pwgen/Dockerfile) | [galvanist/conex:pwgen](https://hub.docker.com/r/galvanist/conex/tags?name=pwgen)
[pycodestyle](pycodestyle) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [pycodestyle](https://pycodestyle.pycqa.org/), the python linter | [Dockerfile](pycodestyle/Dockerfile) | [galvanist/conex:pycodestyle](https://hub.docker.com/r/galvanist/conex/tags?name=pycodestyle)
[pygmentize](pygmentize) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of the [pygmentize](https://pygments.org/docs/cmdline/) utility from the [Pygments](https://pygments.org/) generic syntax highlighter package | [Dockerfile](pygmentize/Dockerfile) | [galvanist/conex:pygmentize](https://hub.docker.com/r/galvanist/conex/tags?name=pygmentize)
[pylint](pylint) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [pylint](https://www.pylint.org/) | [Dockerfile](pylint/Dockerfile) | [galvanist/conex:pylint](https://hub.docker.com/r/galvanist/conex/tags?name=pylint)
[qrencode](qrencode) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [qrencode](https://fukuchi.org/works/qrencode/), the command-line utility for generating QR codes in various formats (PNG, terminal text, etc.) | [Dockerfile](qrencode/Dockerfile) | [galvanist/conex:qrencode](https://hub.docker.com/r/galvanist/conex/tags?name=qrencode)
[shunit2](shunit2) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based containerization of [shUnit2](https://github.com/kward/shunit2/), the "xUnit-based unit test framework for Bourne-based shell scripts." | [Dockerfile](shunit2/Dockerfile) | [galvanist/conex:shunit2](https://hub.docker.com/r/galvanist/conex/tags?name=shunit2)
[vueenv](vueenv) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based image for working with [Vue.js](https://vuejs.org/); meant to be run interactively during development and also used as a builder stage for [Vue CLI](https://cli.vuejs.org/)-based apps in a multi-stage container build | [Dockerfile](vueenv/Dockerfile) | [galvanist/conex:vueenv](https://hub.docker.com/r/galvanist/conex/tags?name=vueenv)
[wireguard](wireguard) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [WireGuard](https://www.wireguard.com/), the free open-source VPN software | [Dockerfile](wireguard/Dockerfile) | [galvanist/conex:wireguard](https://hub.docker.com/r/galvanist/conex/tags?name=wireguard)
[wpa_passphrase](wpa_passphrase) | [`scratch`](https://hub.docker.com/_/scratch/)-based container image which contains the `wpa_passphrase` utility from [Jouni Malinen's wpa_supplicant package](https://w1.fi/wpa_supplicant) | [Dockerfile](wpa_passphrase/Dockerfile) | [galvanist/conex:wpa_passphrase](https://hub.docker.com/r/galvanist/conex/tags?name=wpa_passphrase)
[youtube-dl](youtube-dl) | [`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [youtube-dl](https://ytdl-org.github.io/youtube-dl/), the command-line media download utility with support for [about 1000 sites](https://ytdl-org.github.io/youtube-dl/supportedsites.html) | [Dockerfile](youtube-dl/Dockerfile) | [galvanist/conex:youtube-dl](https://hub.docker.com/r/galvanist/conex/tags?name=youtube-dl)
