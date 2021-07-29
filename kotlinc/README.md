# kotlinc

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of the kotlin compiler

Reference: <https://github.com/JetBrains/kotlin>
Releases: <https://github.com/JetBrains/kotlin/releases>

* I don't see published sums so I calculate them myself 😞
* `bash` is an actual dep 😞
* I don't know if the `JDK_nn` defs are actually needed because things seems to work fine without them.
* You can make the image smaller by setting these image build args to empty strings:

  * `INTERACTIVE_EXTRAS` includes `nano` and `vim` by default
  * `DEV_EXTRAS` includes `gradle` by default

## Usage

Still experimenting with this image. Here are some things I'm experimenting with:

### Interactive

Here's a shell function that you could use to run this image:

```sh

kotlinc() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/kotlinc" \
    "$@"
}

```

### As Build Stage

```Dockerfile
FROM backplane/kotlinc as builder

COPY . .

# RUN some kind of kotlinc thing? help me out, I'm just learning kotlin
```
