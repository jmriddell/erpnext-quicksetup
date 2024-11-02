#!/bin/bash

echo "Creating new site"

set -e

# Load scripts
SCRIPTS_DIR=./utils-scripts
export PATH="$(pwd)/$SCRIPTS_DIR:$PATH"

# Select env file
env_file=defaults.env

frappe_env_file=$(get-file-var $env_file CONFIG_DIR)/$(get-file-var $env_file FRAPPE_ENV_FILE)
other_vars_file=$(get-file-var $env_file CONFIG_DIR)/$(get-file-var $env_file OTHER_VARS_FILE)

echo $frappe_env_file
echo $other_vars_file

db_root_pass=$(get-file-var $frappe_env_file DB_PASSWORD)
admin_password=$(get-file-var $other_vars_file ADMIN_PASSWORD)
site_name=$(get-file-var $env_file SINGLE_SITE_NAME)
echo $site_name


./compose up -d --pull "missing"

./bench new-site --no-mariadb-socket --mariadb-root-password $db_root_pass --admin-password $admin_password $site_name

./bench --site $site_name install-app erpnext