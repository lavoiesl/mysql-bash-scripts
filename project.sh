#!/bin/bash

. config.sh

project_root() {
  [[ $# -gt 1 ]] || return 1
  project=$1
  env=$2

  echo "$projects_root/$project/$env"
}

project_db_config_file() {
  [[ $# -gt 1 ]] || return 1
  project=$1
  env=$2

  root=$(project_root $project $env)
  echo "$root/$projects_db_config_file"
}

project_db() {
  [[ $# -gt 1 ]] || return 1
  project=$1
  env=$2
  
  echo "${project}_${env}"
}

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
