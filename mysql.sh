#!/bin/bash

BASE=/root/wikitesting

MYSQL_RPMS=(
https://repo.mysql.com/yum/mysql-8.0-community/el/7/x86_64/mysql-community-server-8.0.28-1.el7.x86_64.rpm \
https://repo.mysql.com/yum/mysql-8.0-community/el/7/x86_64/mysql-community-client-8.0.28-1.el7.x86_64.rpm \
https://repo.mysql.com/yum/mysql-8.0-community/el/7/x86_64/mysql-community-client-plugins-8.0.28-1.el7.x86_64.rpm \
https://repo.mysql.com/yum/mysql-8.0-community/el/7/x86_64/mysql-community-libs-8.0.28-1.el7.x86_64.rpm \
https://repo.mysql.com/yum/mysql-8.0-community/el/7/x86_64/mysql-community-common-8.0.28-1.el7.x86_64.rpm \
https://repo.mysql.com/yum/mysql-8.0-community/el/7/x86_64/mysql-community-icu-data-files-8.0.28-1.el7.x86_64.rpm \
)
PKGS_TO_REMOVE=(
mariadb # has a deprecated mysql lib
postfix # postfix depends on mariadb
)
RPMDIR=$BASE/RPMS

download_file() {
  local _url="$1"
  local _dir="$2"
  local _fn=$(basename "$_url")
  local _target="${_dir}/${_fn}"
  pushd "$_dir"
  set -x
  wget -N "$_url"
  set +x
  popd
}

set -x

# WORK HERE
# prevent conflicts
yum erase -y "${PKGS_TO_REMOVE[@]}"

# download mysql rpms
mkdir -p "$RPMDIR"
for rpm in "${MYSQL_RPMS[@]}"; do
  download_file "$rpm" "$RPMDIR"
done

# install all downloaded files
yum install $(ls "$RPMDIR"/*.rpm)
