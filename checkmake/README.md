# checkmake

[`scratch`](https://hub.docker.com/_/scratch/)-based single-binary dockerization of [checkmake](https://github.com/mrtazz/checkmake/), the `Makefile` linter

The image runs as a non-root user in the single-binary container. It has its workdir set to `/work`. The multi-stage image build clones the upstream repo and then checks-out the latest git tag before compiling the app.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/checkmake).

## Usage

### Interactive

This shell function demonstrates using this image in place of having the binary installed.

```sh
checkmake() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "backplane/checkmake" \
    "$@"
}
```

Examples sessions using the function:

```sh
$ checkmake
checkmake.

  Usage:
  checkmake [options] <makefile>
  checkmake -h | --help
  checkmake --version
  checkmake --list-rules

  Options:
  -h --help               Show this screen.
  --version               Show version.
  --debug                 Enable debug mode
  --config=<configPath>   Configuration file to read
  --format=<format>       Output format as a Golang text/template template
  --list-rules            List registered rules
```

Checking against this repo's `Makefile`:

```
$ checkmake Makefile 
                                                                
      RULE                 DESCRIPTION             LINE NUMBER  
                                                                
  maxbodylength   Target body for "push" exceeds   25           
                  allowed length of 5 (10).                     
  minphony        Missing required phony target    0            
                  "all"                                         
  minphony        Missing required phony target    0            
                  "test"                                        
```
