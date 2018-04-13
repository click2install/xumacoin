#!/bin/bash

TMP_FOLDER=$(mktemp -d)
CONFIG_FILE="xuma.conf"
DEFAULT_PORT=19777
DEFAULT_RPC_PORT=19643
DEFAULT_SSH_PORT=22
DAEMON_BINARY="xumad"
CLI_BINARY="xuma-cli"
DAEMON_BINARY_FILE="/usr/local/bin/$DAEMON_BINARY"
CLI_BINARY_FILE="/usr/local/bin/$CLI_BINARY"
GITHUB_REPO="https://github.com/xumacoin/xuma-core.git"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

function checks() 
{
  if [[ $(lsb_release -d) != *16.04* ]]; then
    echo -e "${RED}You are not running Ubuntu 16.04. This script is not relevant.${NC}"
    exit 1
  fi

  if [[ $EUID -ne 0 ]]; then
     echo -e "${RED}$0 must be run as root.${NC}"
     exit 1
  fi

  if [ ! -f $DAEMON_BINARY_FILE ]; then
    echo -e "${RED}The Xuma daemon is not where it is expected to be, this script is not relevant.${NC}"
    exit 1
  fi
}

function ask_user() 
{  
  read -e -p "$(echo -e $YELLOW Enter a the username that was used to install the Xuma service: $NC)" -i "" USER_NAME

  if [ -z "$USER_NAME" ]; then
    echo -e "${RED}A username must be provided, so the Xuma configuration can be removed.${NC}"
    ask_user
  fi

  if [ -z "$(getent passwd $USER_NAME)" ]; then
    echo -e "${RED}The $USER_NAME username was not found.${NC}"
    ask_user
  fi
}

function remove_user()
{
    echo -e "${GREEN}Removing the $USER_NAME users home directory and user profile.${NC}"
    userdel -r $USER_NAME >/dev/null 2>&1
}

function remove_service()
{
  SERVICE_FILE=/etc/systemd/system/$USER_NAME.service

  echo -e "${GREEN}Stopping the $USER_NAME.service service.${NC}"
  systemctl stop $USER_NAME.service
  sleep 3

  echo -e "${GREEN}Removing the $SERVICE_FILE.${NC}"
  rm -f $SERVICE_FILE
}

function remove_deamon() 
{
  echo -e "${GREEN}Removing the Xuma binary files from /usr/local/bin.${NC}"
  
  rm -f /usr/local/bin/xuma*
}

function clean_cron() 
{
  echo -e "${GREEN}Cleaning all Xuma related cron jobs.${NC}"

  crontab -l | grep -v '/usr/sbin/logrotate' | crontab -
  crontab -l | grep -v '~/.xuma/clearlog-$USER_NAME.sh' | crontab -
}

function clean_firewall() 
{
  echo -e "${GREEN}Setting up firewall to allow access on port $DAEMON_PORT.${NC}"

  ufw disable >/dev/null 2>&1
  ufw delete allow $DAEMON_PORT/tcp >/dev/null 2>&1
  ufw delete allow $DEFAULT_RPC_PORT/tcp >/dev/null 2>&1
  
  ufw logging on >/dev/null 2>&1

  echo "y" | ufw enable >/dev/null 2>&1
}

function remove_xuma_folder()
{
  echo -e "${GREEN}Cleaning all Xuma files from root home folder.${NC}"

  rm -rf ~/.xuma
}

function cleaup_system() 
{
  ask_user
  remove_service
  remove_deamon
  remove_user
  clean_cron
  clean_firewall
  remove_xuma_folder
  
  echo -e "${GREEN}All files and folders for the Xuma masternode have been removed from this server.${NC}"
}

clear

echo
echo -e "========================================================================================================="
echo -e "${RED}"
echo -e "                                        Yb  dP 8b    d8 Yb  dP"
echo    "                                         YbdP  88b  d88  YbdP"
echo    "                                         dPYb  88YbdP88  dPYb" 
echo -e "                                        dP  Yb 88 YY 88 dP  Yb" 
echo                          
echo -e "${NC}"
echo -e "This script removes all trace of the Xuma masternode if it was installed using click2install's GitHub"
echo -e "script, by performing the following tasks:"
echo -e " - remove the Xuma daemon and cli files"
echo -e " - remove the provided users home folder containing the Xuma configuration"
echo -e " - Remove the Xuma ports from your firewall so they remain blocked"
echo -e " - Remove the Xuma service configuration"
echo -e " - Clean up any cron tasks that were created"
echo
echo -e "this script DOES NOT:"
echo -e " - remove fail2ban"
echo -e " - modify SSH ports"
echo
echo -e "Script created by click2install"
echo -e " - GitHub: https://github.com/click2install/xumacoin"
echo -e " - Discord: click2install#9625"
echo -e " - Xuma: XaKWpVCzJbFHRTTZ9qrbgfsbnmw7yXFzxp"
echo 
echo -e "========================================================================================================="
echo
read -e -p "$(echo -e $YELLOW Do you want to continue? [Y/N] $NC)" CHOICE

if [[ ("$CHOICE" == "n" || "$CHOICE" == "N") ]]; then
  exit 1;
fi

checks
cleaup_system

