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
NAME
    pg_format - PostgreSQL SQL syntax beautifier

DESCRIPTION
    This SQL formatter/beautifier supports keywords from SQL-92, SQL-99,
    SQL-2003, SQL-2008, SQL-2011 and PostgreSQL specifics keywords. Works
    with any other databases too.

    pgFormatter can work as a console program or as a CGI. It will
    automatically detect its environment and format output as text or as
    HTML following the context. It can also return a JSON-formatted response
    if used as CGI with 'Accept: application/json'.

    Keywords highlighting will only be available in CGI context.

  Terminal/console execution
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
                                configuration file unless files ./.pg_format or
                                $HOME/.pg_format or the XDG Base Directory file
                                $XDG_CONFIG_HOME/pg_format/pg_format.conf exist.
        -C | --wrap-comment   : with --wrap-limit, apply reformatting to comments.
        -d | --debug          : enable debug mode. Disabled by default.
        -e | --comma-end      : in a parameters list, end with the comma (default)
        -f | --function-case N: Change the case of the PostgreSQL functions. Default
                                is unchanged: 0. Values: 0=>unchanged, 1=>lowercase,
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
                                Obsolete now, use --extra-keyword 'redshift' instead.
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
        -X | --no-rcfile      : don't read rc files automatically (./.pg_format or
                                $HOME/.pg_format or $XDG_CONFIG_HOME/pg_format).
                                The --config / -c option overrides it.
        --extra-function FILE : file containing a list of functions to use the same
                                formatting as PostgreSQL internal function.
        --extra-keyword FILE  : file containing a list of keywords to use the same
                                formatting as PostgreSQL internal keyword. Use
                                special value 'redshift' for support to Redshift
                                keywords defined internaly in pgFormatter.
        --no-space-function : remove space between function call and the open
                                parenthesis.
        --redundant-parenthesis: do not remove redundant parenthesis in DML.

    Examples:

        cat samples/ex1.sql | pg_format -
        pg_format -n samples/ex1.sql
        pg_format -f 2 -n -o result.sql samples/ex1.sql

  CGI context
    Install pg_format into your cgi-bin folder, grant execution on it as a
    CGI script (maybe you should add the .cgi extension) and get it from
    your favorite browser. Copy files logo_pgformatter.png and
    icon_pgformatter.ico in the CGI directory, pg_format.cgi look for them
    in the same repository.

    You have a live example without limitation than ten thousand characters
    in your SQL query here:

            http://sqlformat.darold.net/

    pg_format will automatically detected that it is running in a CGI
    environment and will output all html code needed to run an online code
    formatter site. There's nothing more to do.

    You need to install the Perl CGI and JSON modules first. If it is not
    already the case do:

            yum install perl-cgi
            yum install perl-json
    or
            apt install libcgi-pm-perl
            apt install libjson-perl

    following your distribution.

INSTALLATION
    Following your Linux distribution you might need to install the autodie
    Perl module:

            sudo yum -y install perl-autodie

    Download the tarball from github and unpack the archive as follow:

            version=5.3 #please use the latest release version from github
            wget https://github.com/darold/pgFormatter/archive/refs/tags/v${version}.tar.gz
            tar xzf v${version}.tar.gz
            cd pgFormatter-${version}/
            perl Makefile.PL
            make && sudo make install
            cd ../ && rm -rf v${version}.tar.gz && rm -rf pgFormatter-${version} #clean up

    This will copy the Perl script pg_format in /usr/local/bin/pg_format
    directory by default and the man page into
    /usr/local/share/man/man1/pg_format.1. Those are the default
    installation directory for 'site' install.

    If you want to install all under /usr/ location, use INSTALLDIRS='perl'
    as argument of Makefile.PL. The script will be installed into
    /usr/bin/pg_format and the manpage into /usr/share/man/man1/pg_format.1.

    For example, to install everything just like Debian does, proceed as
    follow:

            perl Makefile.PL INSTALLDIRS=vendor

    By default INSTALLDIRS is set to site.

    Regression tests can be executed with the following command:

            make test

    If you have docker installed you can build a pgFormatter image using:

            docker build -t darold.net/pgformatter .

    then just use it as

            cat file.sql | docker run --rm -a stdin -a stdout -i darold.net/pgformatter -

SPECIAL FORMATTING
  Option -W, --wrap-after
    This option can be used to set number of column after which lists must
    be wrapped. By default pgFormatter puts every item on its own line. This
    format applies to SELECT and FROM list. For example the following query:

        SELECT a, b, c, d FROM t_1, t_2, t3 WHERE a = 10 AND b = 10;

    will be formatted into with -W 4:

        SELECT a, b, c, d
        FROM t_1, t_2, t3
        WHERE a = 10
            AND b = 10;

    Note this formatting doesn't fits well with sub queries in list.

  Option -w, --wrap-limit
    This option wraps queries at a certain length whatever is the part of
    the query at the limit unless it is a comment. For example if the limit
    is reach in a text constant the text will be wrapped. Indentation is not
    included in the character count. This option is applied in all cases
    even if other options are used.

  Option -C, --wrap-comment
    This option wraps comments at the length defined by -w, --wrap-limit
    whatever is the part of the comment. Indentation is not included in the
    character count.

  Option -t, --format-type
    This option activate an alternative formatting that adds:

      * newline in procedure/function parameter list
      * new line in PUBLICATION and POLICY DDL
      * keep enumeration in GROUP BY clause on a single line

    Expect this list grow following alternative thoughts.

  Option -g, --nogrouping
    By default pgFormatter groups all statements when they are in a
    transaction:

        BEGIN;
        INSERT INTO foo VALUES (1, 'text 1');
        INSERT INTO foo VALUES (2, 'text 2');
        ...
        COMMIT;

    By disabling grouping of statement pgFormatter will always add an extra
    newline characters between statements just like outside a transaction:

        BEGIN;

        INSERT INTO foo VALUES (1, 'text 1');

        INSERT INTO foo VALUES (2, 'text 2');
        ...

        COMMIT;

    This might add readability to not DML transactions.

  Option -L, --no-extra-line
    By default pgFormatter always adds an empty line after the end of a
    statement when it is terminated by a ; except in a plpgsql code block.
    If the extra empty line at end of the output is useless, you can remove
    it by adding this option to the command line.

  Option --extra-function
    pgFormatter applies some formatting to the PostgreSQL internal functions
    call but it can not detect user defined function. It is possible to
    defined a list of functions into a file (one function name per line) and
    give it to pgFormatter through the --extra-function option that will be
    formatter as PostgreSQL internal functions.

  Option --extra-keyword
    pgFormatter applies some formatting to the PostgreSQL internal keywords
    but it can not detect keywords for other database. It is possible to
    defined a list of keywords into a file (one keyword per line) and give
    it to pgFormatter through the --extra-keyword option that will be
    formatter as PostgreSQL internal functions.

    You can also pass a special value 'redshift' that will load the keywords
    defined internally in pgFormatter for this database. This was
    historically possible through the -r | --redshift option that is now
    obsolete and will be removed in the future.

  Option --no-space-function
    Use this option to remove the space character between a function call
    and the open parenthesis that follow. By default pgFormatter adds a
    space character, for example:

        DROP FUNCTION IF EXISTS app_public.hello (a text);

    When this option is used the resulting query is formatted as follow:

        DROP FUNCTION IF EXISTS app_public.hello(a text);

  Option --redundant-parenthesis
    By default, pgFormatter tries to remove redundant parenthesis in DML but
    in some cases they must be preseved. Using this option will keep
    redundant parenthesis untouched.

HINTS
  Configuration
    If the default settings of pg_format doesn't fit all your needs you can
    customize the behavior of pg_format by using a configuration file
    instead of repeating the command line option. By default pgFormatter
    look for files ./.pg_format or $HOME/.pg_format or
    $XDG_CONFIG_HOME/pg_format/pg_format.conf if they exists but you can
    choose an alternate configuration file using command line option -c |
    --config

    To customize the CGI pg_format.cgi look for a configuration file named
    pg_format.conf in the same directory as the CGI script.

    For a sample configuration file see doc/pg_format.conf.sample

    To prevent pg_format to look at $XDG_CONFIG_HOME/pg_format or
    $HOME/.pg_format files you can use the command line option -X |
    --no-rcfile

  Formatting from stdin
    You can execute pg_format without any argument or - to give the SQL code
    to format through stdin.

    If you use the interactive mode you have to type `ctrl+d` after typing
    your SQL statement to format to end the typing.

            $ pg_format
            select * from customers;
            < ctrl+d >

    You can use stdin in a one liner as follow:

            echo "select * from customers;" | pg_format

  Formatting from VI
    With pgFormatter, you can just add the following line to your ~/.vimrc
    file:

            au FileType sql setl formatprg=/usr/local/bin/pg_format\ -

    This lets your gq commands use pgFormatter automagically. For example if
    you are on the first line, typing:

            ESC+gq+G

    will format the entire file.

            ESC+gq+2j

    will format the next two line.

    Thanks to David Fetter for the hint.

    There is also the (Neo)vim plugin for formatting code for many file
    types that support pg_format to format SQL file type. Thanks to Anders
    Riutta for the patch to (Neo)vim.

  Formatting from Atom
    If you use atom as your favorite editor you can install the pg-formatter
    package which is a Node.js wrapper of pgFormatter.

    Features:

      * Format selected text or a whole file via keyboard shortcut or command.
      * Format SQL files on save.

    Installation:

    Search for pg-formatter in Atom UI or get it via command line:

        apm install pg-formatter

    Usage:

    Hit Ctrl-Alt-F to format selected text (or a whole file) or define your
    shortcut:

        'ctrl-alt-p': 'pg-formatter:format'

    Also, you can automatically format SQL files on save (disabled by
    default).

    You can download the package from url:

            https://atom.io/packages/pg-formatter

    the sources are available at https://github.com/gajus/pg-formatter

    Thanks to Alex Fedoseev for the atom package.

  Formatting from Visual Studio
    Thanks to Brady Holt a Visual Studio Code extension is available to
    formats PostgresSQL SQL using pgFormatter.

            https://marketplace.visualstudio.com/items?itemName=bradymholt.pgformatter

    For installation and use have a look at URL above.

  Prevent replacing code snippets
    Using -p or --placeholder command line option it is possible to keep
    code untouched by pgFormatter in your SQL queries. For example, in query
    like:

            SELECT * FROM projects WHERE projectnumber
                    IN <<internalprojects>> AND username = <<loginname>>;

    you may want pgFormatter to not interpret << and >> as bit-shift
    keywords and modify your code snippets. You can use a Perl regular
    expression to instruct pgFormatter to keep some part of the query
    untouched. For example:

            pg_format samples/ex9.sql -p '<<(?:.*)?>>'

    will not format the bit-shift like operators.

    If you would like to wrap queries after 60 characters (-w 60) and to
    apply that limit to comments as well (-C), then urls in comments may get
    wrapped. If you would prefer not to wrap urls, you can use a regular
    expression to avoid wrapping urls. For example:

            pg_format samples/ex62.sql -C -w 60 -p 'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)'

    will wrap the queries and the comments, but not the urls.

  Prevent dynamic code formatting
    By default pgFormatter takes all code between single quote as string
    constant and do not perform any formatting on this code. It is common to
    use a string as code separator to avoid doubling single quote in dynamic
    code generation, in this case pgFormatter can fail to auto detect the
    code separator. By default it will search for any string after the
    EXECUTE keyword starting with dollar sign. If it can not auto detect
    your code separator you can use the command line option -S or
    --separator to set the code separator that must be used.

  Node.js thin-wrapper
    Gajus Kuizinas has written a Node.js wrapper for executing pgFormatter.
    You can find it at https://github.com/gajus/pg-formatter

  Customize CSS for the CGI output
    You can change the HTML style rendered through the default CSS style by
    creating a file named custom_css_file.css into the pgFormatter CGI
    script directory. The default CSS will be fully overridden by this
    custom file content. You have to look at the generated HTML output to
    get the default CSS code used.

  Using pgFormatter as an API
    You may use pgFormatter as an API by setting the 'Accept' HTTP header to
    value 'application/json' when calling it as a CGI app. In case you do
    not want to enable this feature, set "$self->{ 'enable_api' } = 0" in
    the "set_config" sub of lib/pgFormatter/CGI.pm.

AUTHORS
    pgFormatter is an original work from Gilles Darold with major code
    refactoring by Hubert depesz Lubaczewski.

COPYRIGHT
    Copyright 2012-2025 Gilles Darold. All rights reserved.

LICENSE
    pgFormatter is free software distributed under the PostgreSQL Licence.

    A modified version of the SQL::Beautify Perl Module is embedded in
    pgFormatter with copyright (C) 2009 by Jonas Kramer and is published
    under the terms of the Artistic License 2.0.

```

### Example

The following shell function can assist in running this image interactively:

```sh
# using "-i" for editing formatting the file in-place
docker run --rm --volume "$(pwd):/work" backplane/pgformatter -i query.sql
```
