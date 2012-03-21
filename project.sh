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
