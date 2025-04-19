#!/bin/bash
log="/var/log/backup.log"
ts="$(date '+%F %T')"
bkdir="/home/ubuntu/backups"

#exit codes
state=0

#File Creation
if [ ! -f $bkdir ]
then
    mkdir -p "$bkdir"
    state=$((state|1))
fi

# Project backup
prj="api_backup_$(date +%F).tar.gz"
tar -czf "$bkdir/$orj" /var/www/Studs && echo "[$ts] Project backup: $prj OK" >> "$log" \
  || echo "[$ts] Project backup failed" >> "$log"
state=$((state|2))

# DB backup
dbf="db_backup_$(date +%F).sql"
pg_dump -U a_cole -h localhost deploy > "$bkdir/$dbf" && echo "[$ts] DB backup: $dbf OK" >> "$log" \
  || echo "[$ts] DB backup failed" >> "$log"
state=$((state|4))

# Cleanup >7 days
find "$bkdir" -type f -mtime +7 -exec rm -f {} \; && echo "[$ts] Old backups cleaned" >> "$log"
state=$((state|8))

exit $state
