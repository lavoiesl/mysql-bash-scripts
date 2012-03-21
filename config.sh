#!/bin/bash

mysql=mysql
host=localhost
port=3306
root_user=root
root_pass=root

passwd_file=/root/mysql-passwds

projects_root=/mnt/data/environments
projects_db_config_file=confs/database.ini

# Override configs with local file
[[ -f config-local.sh ]] && . config-local.sh

mysql_cmd="$mysql --user=$root_user --password=$root_pass --host=$host --port=$port"

run_sql() {
  echo "$1" | $mysql_cmd
}
