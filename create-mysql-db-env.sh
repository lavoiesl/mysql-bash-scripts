#!/bin/bash

. config.sh
. user.sh
. database.sh
. project.sh
. config_file.sh

project="$1"
envs="dev stage"

if [[ -z "$project" ]]; then
  echo "Usage: $0 project [environment]" >&2
  exit 1
fi

shift

[[ -n "$@" ]] && envs="$@"

## User 

user=$project

pass=$(get_user_pass $user)

ensure_user_usage $user $pass
grant_user_database $user "${user}_%"

## Database
echo

for env in $envs; do
  database=$(project_db $project $env)

  ensure_database $database

  config_file=$(project_db_config_file $project $env)
  write_db_config_file "$config_file" $user $pass $database
done
