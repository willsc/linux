#!/bin/bash  
# 
# Add user to sudoers (ALL NOPASSWD).
# Usage: $0 [username] (if no username provided, the username of the current user is used)
#

[ $UID -eq 0 ] || 
{ echo "This script needs to be run with sudo -- \"sudo `basename $0`\"."; exit 1; }

[ -z "$1" ] && SUDOERS_USERNAME=$SUDO_USER || SUDOERS_USERNAME=$1

[ -z $SUDOERS_USERNAME ] && { echo "error SUDO_USER env variable is not set."; exit 1; }

echo "WARNING !!!"
echo "This script will add $SUDOERS_USERNAME to /etc/sudoers.d with ALL access and NOPASSWD."
echo "However, it will not add the user to sudoers/wheel/... group. If it's not already a member of such a group, you must add it yourself!"

echo -n "Checking if /etc/sudoers.d exists..."
[ -d /etc/sudoers.d ] || { echo "error /etc/sudoers.d does not exist."; exit 1; }
echo "ok."

SUDOER_FILE_NAME="00${SUDOERS_USERNAME}_all"

echo -n "Checking if $SUDOER_FILE_NAME already exists..."
[ -e /etc/sudoers.d/$SUDOER_FILE_NAME ] &&
{ echo "error file already exists, aborting."; exit 1; }
echo "ok."

echo -n "Creating file $SUDOER_FILE_NAME..."
(umask 0226;
echo -e "${SUDOERS_USERNAME}\tALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$SUDOER_FILE_NAME")
echo "ok."

exit 0

