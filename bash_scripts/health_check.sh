#!/bin/bash
log="/var/log/server_health.log"
ts="$(date '+%F %T')"

# exit_code
e_status=0

# Helpers
log() { echo "[$ts] $1" >> "$log"; }

# CPU, Mem, Disk
cpu=$(top -bn1 | awk '/Cpu\(s\):/ {print 100-$8"%"}')
e_status=$((e_status|1))

mem=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)", $3,$2,$3*100/$2 }')
e_status=$((e_status|2))

disk=$(df / | awk 'NR==2 {gsub(/%/, "",$5); print $5}')
e_status=$((e_status|4))

# Web server status (Nginx)
if systemctl is-active nginx >/dev/null; then
  server_status="OK"; else server_status="FAIL"
  e_status=$((e_status|8))
fi

# API checks
check_endpoint(){
  status=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:5000"$1")
  [[ "$status" == "200" ]] && echo "OK" || echo "FAIL"
  e_status=$((e_status|16))
}

students=$(check_endpoint /students)
subjects=$(check_endpoint /subjects)

# Log
log "CPU: $cpu | MEM: $mem | DISK: $disk | NGINX: $server_status | /students: $students | /subjects: $subjects"
e_status=$((e_status|32))

# Warnings
if (( disk > 90 )): then
 log "WARNING: Disk usage above 90%! ($disk%)"
 e_status=$((e_status|64))
fi

[[ "$server_status" != "OK" ]] && log "WARNING: Nginx is down" 
e_status=$((e_status|128))

if [[ "$students" != "OK" && "$subjects" != "OK" ]]
then
    log "WARNING: API endpoint failure"
    e_status=$((e_status|256))
else
   [[ "$students" != "OK" ]] && log "WARNING: student endpoint is down" || [[ "$subjects" != "OK" ]] && log "WARNING: subject endpoint is down"
   e_status=$((e_status|256))
fi

exit $e_status

