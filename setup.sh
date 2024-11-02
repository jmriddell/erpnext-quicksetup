#!/bin/bash

set -e

# Load scripts
SCRIPTS_DIR=./utils-scripts
export PATH="$(pwd)/$SCRIPTS_DIR:$PATH"

# Select env file
env_file=defaults.env

clone-and-checkout $(get-file-var $env_file REPO_URL) $(get-file-var $env_file REPO_REF) $(get-file-var $env_file REPO_CLONE_PATH)

mkdir $(get-file-var $env_file CONFIG_DIR)

# Make frappe env file
frappe_env_file=$(get-file-var $env_file CONFIG_DIR)/$(get-file-var $env_file FRAPPE_ENV_FILE)
set-file-var $frappe_env_file ERPNEXT_VERSION $(get-file-var $env_file ERPNEXT_VERSION)
set-file-var $frappe_env_file DB_PASSWORD $(generate-password 16)
set-file-var $frappe_env_file FRAPPE_SITE_NAME_HEADER $(get-file-var $env_file SINGLE_SITE_NAME)
set-file-var $frappe_env_file HTTP_PUBLISH_PORT $(get-file-var $env_file HTTP_PUBLISH_PORT)

# Make other vars file
other_vars_file=$(get-file-var $env_file CONFIG_DIR)/$(get-file-var $env_file OTHER_VARS_FILE)
set-file-var $other_vars_file ADMIN_PASSWORD $(generate-password 16)

# Generate YAML
./compose \
  -f $(get-file-var $env_file REPO_CLONE_PATH)/compose.yaml \
  -f $(get-file-var $env_file REPO_CLONE_PATH)/overrides/compose.noproxy.yaml \
  -f $(get-file-var $env_file REPO_CLONE_PATH)/overrides/compose.mariadb.yaml \
  -f $(get-file-var $env_file REPO_CLONE_PATH)/overrides/compose.redis.yaml \
  config > $(get-file-var $env_file CONFIG_DIR)/$(get-file-var $env_file FRAPPE_COMPOSE_FILE)