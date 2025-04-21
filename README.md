# CS 421 API Assignment

## Project Overview
This project is a simple API with two endpoints:
- /students: Returns a list of students.
- /subjects: Returns subjects for the Software Engineering program organized by academic year.

## Setup Instructions
1. Clone the repository:
   git clone https://github.com/AlaxCole/Studs

2. Navigate into the project directory and create a virtual environment:

3. Run the API:
   
## API Endpoints
- `GET /students` - Returns JSON list of students.
- `GET /subjects` - Returns JSON object of subjects by year.

## bash_scripts

### health_check.sh  
Monitors CPU, memory, disk, web server and API endpoints; logs warnings if thresholds crossed.

### backup_api.sh  
Archives project and database daily; prunes backups older than 7 days. This follows a full-backup scheme.

### update_server.sh  
Automates `apt update/upgrade`, `git pull`, and Nginx restart, aborts on failure.

### Backup Schemes
1. Full Backup: Dumps everything everytime
Pros: Simple restoration of data, and its all in single file
Cons: Slow and requires large storage, especially without a retention policy

2. Incremental Backup: It only backs up changes, after a full backup. For example, the WAL-based scheme for Postgres.
Pros: Quick and smaller backups
Cons: Complex restores as it must replay increments

3. Differential Backup: Dumps all the changes since a full backup was initiated.
Pros: Faster than a full backup, and simpler than incremental backup
Cons: Grows bigger each time until next full backup
 
### Setup & Usage  
1. Copy scripts to your server under `~/bash_scripts`.  
2. `chmod +x bash_scripts/*.sh`  
3. Dependencies: `curl`, `tar`, `pg_dump` (PostgreSQL client), `git`, `systemctl`.

### Scheduling (cron)
```cron
# Run health_check every 6h
0 */6 * * * /var/www/Studs/bash_scripts/health_check.sh

# Run backup_api daily at 2AM
0 2 * * * /var/www/Studs/bash_scripts/backup_api.sh

# Run update_server every 3 days at 3AM (Take it out of the repo directory, for safety)
0 3 */3 * * /home/ubuntu/update_server.sh

## Deployment
The API has been deployed on an AWS Ubuntu server. Access it at: [http://13.61.9.123](http://13.61.9.123)


