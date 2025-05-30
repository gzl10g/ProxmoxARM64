#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/asylumexp/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/asylumexp/Proxmox/raw/main/LICENSE
# Source: https://pocketbase.io/

# App Default Values
APP="Pocketbase"
var_tags="database"
var_cpu="1"
var_ram="512"
var_disk="8"
var_os="debian"
var_version="12"
var_unprivileged="1"

# App Output & Base Settings
header_info "$APP"
base_settings

# Core
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources
  if [[ ! -f /etc/systemd/system/pocketbase.service || ! -x /opt/pocketbase/pocketbase ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
  msg_info "Stopping ${APP}"
  systemctl stop pocketbase
  msg_ok "Stopped ${APP}"

  msg_info "Updating ${APP}"
  /opt/pocketbase/pocketbase update
  msg_ok "Updated ${APP}"

  msg_info "Starting ${APP}"
  systemctl start pocketbase
  msg_ok "Started ${APP}"
  msg_ok "Updated Successfully"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:8080/_${CL}"
