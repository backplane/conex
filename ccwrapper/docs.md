# package index

This command line (or something like it) can be used to build up some of the info in the README.md

```sh
apk list -I -q \
| xargs apk info --all --format json \
| jq -r --arg path "$PATH" '
  def on_path($dirs):
    . as $f
    | ($f | split("/")[:-1] | join("/")) as $dir
    | ($dirs | index($dir)) != null;

  ($path | split(":")) as $pathdirs
  | .[]
  | {
      package: .name,
      version: .version,
      executables: (
        .contents
        | map("/" + .)
        | map(select(on_path($pathdirs)))
      ),
      description: .description
    }
  | select(.executables | length > 0)
'
```
