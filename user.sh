#!/bin/bash

. config.sh

# hexadecimal password generator
# with 20 chars, it is way enough entropy
genpass() {
  length=20
  [[ "$1" -gt 0 ]] && length=$1

  md5="md5"
  which $md5 >/dev/null || md5="md5sum"

  head -c 100 /dev/urandom | $md5 | head -c $length
}

# ensure created and secure permissions
ensure_passwd_file() {
  sudo touch $passwd_file
  sudo chmod 600 $passwd_file
}

get_user_pass() {
  [[ $# -gt 0 ]] || return 1
  user=$1

  ensure_passwd_file

  pass=$(read_user_pass $user || gen_user_pass $user)
  echo $pass
}

read_user_pass() {
  [[ $# -gt 0 ]] || return 1
  user=$1

  pass=$(sudo grep "^$user" $passwd_file | cut -d = -f 2 | sed 's/^ +//' | sed 's/ +$//')

  # Strip quote. In another line to prevent quote hell above
  pass="$(echo $pass | sed "s/'//g")"

  [[ -z "$pass" ]] && return 1

  echo "Password already generated for $user." >&2
  echo $pass
}

gen_user_pass() {
  [[ $# -gt 0 ]] || return 1
  user=$1

  echo "Generating password for user $user." >&2
  pass=$(genpass 20)
  save_user_pass $user $pass

  echo $pass
}

save_user_pass() {
  [[ $# -gt 1 ]] || return 1
  user=$1
  pass=$2

  echo "Saving informations in $passwd_file." >&2
  echo "$user='$pass'" | sudo tee -a $passwd_file > /dev/null
}

ensure_user_usage() {
  [[ $# -gt 1 ]] || return 1
  user=$1
  pass=$2

  echo "Refreshing password for user $user." >&2
  run_sql "GRANT USAGE ON * . * TO '$user'@'$host' IDENTIFIED BY '$pass';
           FLUSH PRIVILEGES;"
}
