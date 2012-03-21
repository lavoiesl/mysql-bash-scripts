#!/bin/bash

. config.sh

database_exists() {
  [[ $# -gt 0 ]] || return 2
  database=$1

  sql="SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '$database';"
  result=$(run_sql "$sql")
  
  [[ -n "$result" ]]
}

ensure_database() {
  [[ $# -gt 0 ]] || return 2
  database=$1

  if database_exists $database; then
    echo "Database $database already exists." >&2
  else
    echo "Creating database $database." >&2
    run_sql "CREATE DATABASE $database;"
  fi
}

grant_user_database() {
  [[ $# -gt 1 ]] || return 1
  user=$1
  database=$2

  echo "Refreshing privileges for user $user on database $database." >&2
  run_sql "GRANT ALL PRIVILEGES ON \`$database\`.* TO '$user'@'$host';
           FLUSH PRIVILEGES;"
}
