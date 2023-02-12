# snakeeyes

[`scratch`](https://hub.docker.com/_/scratch/)-based single-binary container image featuring [snakeeyes](https://github.com/glvnst/snakeeyes), the command-line passphrase generator

As [the site](https://github.com/glvnst/snakeeyes) says:

> This command-line utility generates random [diceware](https://en.wikipedia.org/wiki/Diceware)-style passphrases using the [EFF's passphrase word lists](https://www.eff.org/deeplinks/2016/07/new-wordlists-random-passphrases), including their [FANDOM Wikia-based word lists](https://www.eff.org/deeplinks/2018/08/dragon-con-diceware). For reference, the EFF provides detailed [instructions for generating passphrases using these word lists](https://www.eff.org/dice) with regular [dice](https://en.wikipedia.org/wiki/Dice). This program replaces the table dice with a [cryptographically secure pseudorandom number generator](https://en.wikipedia.org/wiki/Cryptographically_secure_pseudorandom_number_generator): the one from your operating system as proxied by [go's crypto/rand package](https://godoc.org/crypto/rand).

The image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/snakeeyes).

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

snakeeyes() {
  docker run \
    --rm \
    --interactive \
    --tty \
    "backplane/snakeeyes" \
    "$@"
}

```
