# pwgen

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [pwgen](https://github.com/tytso/pwgen) -- the password generator written by [Theodore Ts'o](https://github.com/tytso)

This is the same code base as the [pwgen package on debian](https://packages.debian.org/stable/pwgen).

## Usage

```
Usage: pwgen [ OPTIONS ] [ pw_length ] [ num_pw ]

Options supported by pwgen:
  -c or --capitalize
	Include at least one capital letter in the password
  -A or --no-capitalize
	Don't include capital letters in the password
  -n or --numerals
	Include at least one number in the password
  -0 or --no-numerals
	Don't include numbers in the password
  -y or --symbols
	Include at least one special symbol in the password
  -r <chars> or --remove-chars=<chars>
	Remove characters from the set of characters to generate passwords
  -s or --secure
	Generate completely random passwords
  -B or --ambiguous
	Don't include ambiguous characters in the password
  -h or --help
	Print a help message
  -H or --sha1=path/to/file[#seed]
	Use sha1 hash of given file as a (not so) random generator
  -C
	Print the generated passwords in columns
  -1
	Don't print the generated passwords in columns
  -v or --no-vowels
	Do not use any vowels so as to avoid accidental nasty words
```

### Interactive

Here is a shell function that can simplify use of this image. Note that if you use it this way (without a bind-mount) you won't have access to the `-H` / `--sha1=` feature.

```sh

pwgen() {
  docker run \
    --rm \
    --interactive \
    --tty \
    "backplane/pwgen" \
    "$@"
}

```
