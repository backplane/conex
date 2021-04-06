# mssql-scripter

[`debian:buster-slim`](https://hub.docker.com/_/debian/)-based dockerization of [mssql-scripter](https://github.com/microsoft/mssql-scripter), a multi-platform command line experience for scripting SQL Server databases.

As the site says:

> mssql-scripter is the multiplatform command line equivalent of the widely used Generate Scripts Wizard experience in SSMS. You can use mssql-scripter on Linux, macOS, and Windows to generate data definition language (DDL) and data manipulation language (DML) T-SQL scripts for database objects in SQL Server running anywhere, Azure SQL Database, and Azure SQL Data Warehouse. You can save the generated T-SQL script to a .sql file or pipe it to standard nix utilities (for example, sed, awk, grep) for further transformations. You can edit the generated script or check it into source control and subsequently execute the script in your existing SQL database deployment processes and DevOps pipelines with standard multiplatform SQL command line tools such as sqlcmd.
>
> mssql-scripter is built using Python and incorporates the usability principles of the new Azure CLI 2.0 tools.

## Usage

### Interactive

The following shell function can assist in running this image interactively:

```sh

mssql_scripter() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:mssql-scripter" \
    "$@"
}

```
