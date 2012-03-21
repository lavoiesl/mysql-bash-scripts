# MySQL Bash Scripts

Collection of Bash script to manage MySQL databases, users and privileges

Also include utilities to output ini configuration to a project folder, to use in a Web project for example.

## Configuration

The `config.sh` should not be touch; instead, create a `config-local.sh` and overwrite any configuration.

## Usage

Those files define functions to be used as you wish:

  * database.sh
  * project.sh
  * user.sh
  * config_file.sh

Function names are pretty self-explanatory, look at the code to know what they do.

## Example

See `create-mysql-db-env.sh` for a full example