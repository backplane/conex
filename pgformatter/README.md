# pgformatter

[`perl:5-slim`](https://hub.docker.com/_/perl)-based dockerization of [`pgFormatter`](https://github.com/darold/pgFormatter) the PostgreSQL SQL syntax beautifier

As the site says:

> This SQL formatter/beautifier supports keywords from SQL-92, SQL-99, SQL-2003, SQL-2008, SQL-2011 and PostgreSQL specifics keywords. Works with any other databases too.
>
> pgFormatter can work as a console program or as a CGI. It will automatically detect its environment and format output as text or as HTML following the context.

The source code for this image is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/pgformatter).

## Usage

### Help Text

The program emits the following help text when invoked with the `-h` or `--help` arguments.

```
Usage: pg_format [options] file.sql

    PostgreSQL SQL queries and PL/PGSQL code beautifier.

Arguments:

    file.sql can be a file, multiple files or use - to read query from stdin.

    Returning the SQL formatted to stdout or into a file specified with
    the -o | --output option.

Options:

    -a | --anonymize      : obscure all literals in queries, useful to hide
                            confidential data before formatting.
    -b | --comma-start    : in a parameters list, start with the comma (see -e)
    -B | --comma-break    : in insert statement, add a newline after each comma.
    -c | --config FILE    : use a configuration file. Default is to not use
                            configuration file or ~/.pg_format if it exists.
    -C | --wrap-comment   : with --wrap-limit, apply reformatting to comments.
    -d | --debug          : enable debug mode. Disabled by default.
    -e | --comma-end      : in a parameters list, end with the comma (default)
    -f | --function-case N: Change the case of the reserved keyword. Default is
                            unchanged: 0. Values: 0=>unchanged, 1=>lowercase,
                            2=>uppercase, 3=>capitalize.
    -F | --format STR     : output format: text or html. Default: text.
    -g | --nogrouping     : add a newline between statements in transaction
                            regroupement. Default is to group statements.
    -h | --help           : show this message and exit.
    -i | --inplace        : override input files with formatted content.
    -k | --keep-newline   : preserve empty line in plpgsql code.
    -L | --no-extra-line  : do not add an extra empty line at end of the output.
    -m | --maxlength SIZE : maximum length of a query, it will be cutted above
                            the given size. Default: no truncate.
    -M | --multiline      : enable multi-line search for -p or --placeholder.
    -n | --nocomment      : remove any comment from SQL code.
    -N | --numbering      : statement numbering as a comment before each query.
    -o | --output file    : define the filename for the output. Default: stdout.
    -p | --placeholder RE : set regex to find code that must not be changed.
    -r | --redshift       : add RedShift keyworks to the list of SQL keyworks.
                            Obsolete now, use --extra-keyword 'reshift' instead.
    -s | --spaces size    : change space indent, default 4 spaces.
    -S | --separator STR  : dynamic code separator, default to single quote.
    -t | --format-type    : try another formatting type for some statements.
    -T | --tabs           : use tabs instead of space characters, when used
                            spaces is set to 1 whatever is the value set to -s.
    -u | --keyword-case N : Change the case of the reserved keyword. Default is
                            uppercase: 2. Values: 0=>unchanged, 1=>lowercase,
                            2=>uppercase, 3=>capitalize.
    -U | --type-case N    : Change the case of the data type name. Default is
                            lowercase: 1. Values: 0=>unchanged, 1=>lowercase,
                            2=>uppercase, 3=>capitalize.
    -v | --version        : show pg_format version and exit.
    -w | --wrap-limit N   : wrap queries at a certain length.
    -W | --wrap-after N   : number of column after which lists must be wrapped.
                            Default: puts every item on its own line.
    -X | --no-rcfile      : do not read ~/.pg_format automatically. The
                            --config / -c option overrides it.
    --extra-function FILE : file containing a list of functions to use the same
                            formatting as PostgreSQL internal function.
    --extra-keyword FILE  : file containing a list of keywords to use the same
                            formatting as PostgreSQL internal keyword. Use
			    special value 'redshift' for support to Redshift
			    keywords defined internaly in pgFormatter.
    --no-space-function : remove space between function call and the open
                            parenthesis.

Examples:

    cat samples/ex1.sql | /usr/local/bin/pg_format -
    /usr/local/bin/pg_format -n samples/ex1.sql
    /usr/local/bin/pg_format -f 2 -n -o result.sql samples/ex1.sql
```

### Example

The following shell function can assist in running this image interactively:

```sh
# using "-i" for editing formatting the file in-place
docker run --rm --volume "$(pwd):/work" backplane/pgformatter -i query.sql
```
