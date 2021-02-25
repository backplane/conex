# sql-formatter

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [sql-formatter](https://github.com/zeroturnaround/sql-formatter) the util for formatting SQL queries

As the site says:

> SQL Formatter is a JavaScript library for pretty-printing SQL queries [...] SQL formatter supports the following dialects:
>
> - **sql** - [Standard SQL](https://en.wikipedia.org/wiki/SQL:2011)
- **mariadb** - [MariaDB](https://mariadb.com/)
- **mysql** - [MySQL](https://www.mysql.com/)
- **postgresql** - [PostgreSQL](https://www.postgresql.org/)
- **db2** - [IBM DB2](https://www.ibm.com/analytics/us/en/technology/db2/)
- **plsql** - [Oracle PL/SQL](http://www.oracle.com/technetwork/database/features/plsql/index.html)
- **n1ql** - [Couchbase N1QL](http://www.couchbase.com/n1ql)
- **redshift** - [Amazon Redshift](https://docs.aws.amazon.com/redshift/latest/dg/cm_chap_SQLCommandRef.html)
- **spark** - [Spark](https://spark.apache.org/docs/latest/api/sql/index.html)
- **tsql** - [SQL Server Transact-SQL](https://docs.microsoft.com/en-us/sql/sql-server/)

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

sql_formatter() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:sql-formatter" \
    "$@"
}

```

when run interactively with the `-h` argument, the container produces the following usage text:

```
usage: sql-formatter [-h] [-o OUTPUT] [-l {db2,mariadb,mysql,n1ql,plsql,postgresql,redshift,spark,sql,tsql}] [-i N | -t] [-u] [--lines-between-queries N]
                     [--version]
                     [FILE]

SQL Formatter

positional arguments:
  FILE                  Input SQL file (defaults to stdin)

optional arguments:
  -h, --help            show this help message and exit
  -o OUTPUT, --output OUTPUT
                        File to write SQL output (defaults to stdout)
  -l {db2,mariadb,mysql,n1ql,plsql,postgresql,redshift,spark,sql,tsql}, --language {db2,mariadb,mysql,n1ql,plsql,postgresql,redshift,spark,sql,tsql}
                        SQL Formatter dialect (defaults to basic sql)
  -i N, --indent N      Number of spaces to indent query blocks (defaults to 2)
  -t, --tab-indent      Indent query blocks with tabs instead of spaces
  -u, --uppercase       Capitalize language keywords
  --lines-between-queries N
                        How many newlines to insert between queries (separated by ";")
  --version             show program's version number and exit
```
