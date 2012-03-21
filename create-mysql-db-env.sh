#!/bin/bash

project="$1"
envs="dev stage"
host="localhost"
root_user="root"
root_pass="root"
mysql_cmd="mysql -u$root_user -p$root_pass"
passwd_file=/root/mysql-passwds

if [[ -z "$project" ]]; then
  echo "Usage: $0 project [environment]" >&2
  exit 1
fi

shift

[[ -n "$@" ]] && envs="$@"

## User 

genpass() {
  length=15
  [[ "$1" -gt 0 ]] && length=$1

  md5="md5"
  which $md5 >/dev/null || md5="md5sum"

  head -c 100 /dev/urandom | $md5 | head -c $length
}

user=$project

# ensure created and secure permissions
sudo touch $passwd_file
sudo chmod 600 $passwd_file

pass=$(sudo grep "^$user" $passwd_file | cut -d = -f 2 | sed 's/^ +//' | sed 's/ +$//')
# Strip quote. In another line to prevent quote hell above
pass="$(echo $pass | sed "s/'//g")" 

if [[ -z $pass ]]; then
  echo "Generating password for user $user."
  pass=$(genpass 20)
  echo "Saving informations in $passwd_file."
  echo "$user='$pass'" | sudo tee -a $passwd_file > /dev/null
else
  echo "Password already generated for $user."
fi

echo "Refreshing privileges for user $user in database"
echo "GRANT USAGE ON * . * TO '$user'@'$host' IDENTIFIED BY '$pass';
      GRANT ALL PRIVILEGES ON \`${user}_%\`.* TO '$user'@'$host';
      FLUSH PRIVILEGES;" | $mysql_cmd

## Database
echo

for env in $envs; do
  database=$project"_"$env

  if [[ -z "$(echo SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = \'$database\' | $mysql_cmd)" ]]; then
    echo "Creating database $database."
    echo "CREATE DATABASE IF NOT EXISTS $database;" | $mysql_cmd
  else
    echo "Database $database already exists."
  fi


  config_file="/mnt/data/environments/$project/$env/confs/database.ini"
  mkdir -p "$(dirname $config_file)"

  echo "  Saving informations in $config_file."
  echo "host='localhost'
user='$user'
pass='$pass'
name='$database'" > "$config_file"
done
