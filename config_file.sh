#!/bin/bash

. config.sh

write_db_config_file() {
  [[ $# -gt 3 ]] || return 1
  config_file="$1"
  user=$2
  pass=$3
  database=$4

  # ensure folder exists
  mkdir -p "$(dirname $config_file)"

  echo "  Saving informations in $config_file." >&2
  echo "host='$host'
user='$user'
pass='$pass'
name='$database'" > "$config_file"
}
