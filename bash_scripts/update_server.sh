#!/bin/bash
log="/var/log/update.log"
ts="$(date '+%F %T')"
repo_DIR="/var/www/Studs"

# Assuming that the the path to the log file exists and appropriate permissions have been set 

log(){ echo "[$ts] $1" >> "$log"; }

status=0

# Update packages
sudo apt update && sudo apt upgrade -y && log "System packages upgraded" || log "Package upgrade failed"; status=$((status | 1))

# Pull latest code
cd "$repo_DIR"
if git pull origin main; then
  log "Git pull OK"
  sudo systemctl restart myapp nginx
  log "Nginx  restarted"
  status=$((status | 2))
else
  log "Git pull failed"
  status=$((status | 2))
fi

clear
status=$((status | 4))

exit $status

