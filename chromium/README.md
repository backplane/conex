# chromium

[`debian:unstable-slim`](https://hub.docker.com/_/debian/)-based dockerization of the Google Chromium web browser

The `Dockerfile`, `seccomp.json`, and `fonts.conf` in this repo were originally forked from [jessfraz' chromium stable Dockerfile](https://github.com/jessfraz/dockerfiles/tree/master/chromium/). This repo contains some minor reformatting and adds site-specific browser helpers.

**In order to run this container with Docker Desktop for Mac you will need to install [XQuartz](https://www.xquartz.org/)**

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/chromium).

## Usage

### Site-specific Browser Containers

This container includes a helper script which can be used to run site-specific browsers.

First either [get the utility from the repo](https://github.com/backplane/conex/blob/main/chromium/chromium_ssb.sh) or from the container image with this command:

```shell=sh
$ docker run --rm backplane/chromium --get-util >chromium_ssb.sh
2023-02-21T19:37:12 entrypoint writing chromium_ssb.sh to STDOUT
$ ls
chromium_ssb.sh
$ chmod +x chromium_ssb.sh
```

The utility works by creating named Docker volumes based on the "name" you choose. You can make isolated browsers for any purpose, but people often make a `work` browser, a `socialmedia` browser, a `news` browser, etc. These are completely isolated from each other and they retain their storage (including settings and plugins) across container runs.

To create a launch a site-specific browser *for work stuff*, use this command:

```shell=sh
$ ./chromium_ssb.sh work
```

The program will print it's configuration information and the ID of the container. Then it will open your X server application and start the Chromium browser:

```shell=sh
$ ./chromium_ssb.sh work
2023-02-21T21:14:28+0100 chromium_ssb applying OS-specific customizations for macOS
2023-02-21T21:14:28+0100 chromium_ssb exporting host xauth cookie to xauth volume
2023-02-21T21:14:29+0100 chromium_ssb starting container
docker run
--volume /Users/user/Downloads:/home/user/Downloads
--tty
--cpu-quota 75000
--env DISPLAY=host.docker.internal:0
--memory 4g
--name chromium_ssb_work
--security-opt seccomp=/Users/user/.chromium_ssb/seccomp.json
--volume chromium_ssb_work:/data
--volume chromium_ssb__auth:/xauth:ro
--detach
--rm backplane/chromium
--use-gl=swiftshader
--disable-dev-shm-usage
--disable-audio-output
--reset-variation-state
--disable-field-trial-config

3726023d196f14c5f31bf789ad6c01656d18313101dbe0319e20907b36803b31
```

When you close the last window the container will exit. You can simultaneously open as many different ssb containers as you like. To re-open that browser use the same command as before: `./chromium_ssb.sh work`

#### Monitoring

You can use `docker stats` to keep an eye on the resources used by each container.

```shell=sh
$ docker stats
CONTAINER ID   NAME                  CPU %     MEM USAGE / LIMIT   MEM %     NET I/O           BLOCK I/O         PIDS
484b76f73352   chromium_ssb_reddit   23.94%    311MiB / 4GiB       7.59%     29.8MB / 3.03GB   77.8kB / 291MB    101
cd060f67083b   chromium_ssb_work     57.79%    294.3MiB / 4GiB     7.19%     15.7MB / 7.75GB   32.8kB / 194MB    79
```

#### Storage

After launching one or more of these site specific browsers, you will have named storage volumes for each browser and one `__auth` volume which is used by all of them:

```shell=sh
$ docker volume ls
local     chromium_ssb__auth
local     chromium_ssb_news
local     chromium_ssb_test
local     chromium_ssb_work
```

You can completely remove a browser (all settings, plugins, history, downloads, etc.) with this command:

```shell=sh
$ docker volume rm chromium_ssb_work
chromium_ssb_work
```

#### Environment Variable Configuration

Env. Variable    | Explanation                                                       | Default
---------------- | ----------------------------------------------------------------- | ---------------------------
`SSB_BASE`       | a host subdir where the seccomp profile will be stored            | `~/.chromium_ssb`
`SSB_CPU_QUOTA`  | the percentage of a single CPU the browser can consume            | `75000` (75% of one CPU)
`SSB_DEBUG`      | set non-empty to cause the `chromium_ssb.sh` to run with `set -x` | `""` (empty)
`SSB_FOREGROUND` | set non-empty to cause the container to run in the foreground     | `""` (empty)
`SSB_IMAGE`      | the browser image to run                                          | `backplane/chromium:latest`
`SSB_MEM`        | memory limit, unit can be one of `b`, `k`, `m`, or `g`            | `4g`
`SSB_NO_DL`      | set non-empty to prevent mounting `~/Downloads` in the container  | `""` (empty)
`SSB_XSERVER`    | (macOS specific) the name of the X11 server application           | `Xquartz`
