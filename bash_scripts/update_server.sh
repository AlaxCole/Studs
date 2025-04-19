#!/bin/bash
log="/var/log/update.log"
ts="$(date '+%F %T')"
repo_DIR="/var/www/Studs"

log(){ echo "[$ts] $1" >> "$log"; }

# Update packages
sudo apt update && sudo apt upgrade -y && log "System packages upgraded" || { log "Package upgrade failed"; status=1 }

# Pull latest code
cd "$repo_DIR"
if git pull origin main; then
  log "Git pull OK"
  sudo systemctl restart myapp nginx
  log "Nginx  restarted";
else
  log "Git pull failed"
fi
status=$((status|2))

exit $status
