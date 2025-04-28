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

## Docker

### 1. Building the Docker Image

Before you can containerize your API, make sure you have Docker installed on yo>

1. **Build the image:**
   ```bash
   docker build -t yourhubuser/your-api:latest .

2.  **(Optional) Force a clean build:**
If you change dependencies or your Dockerfile, you may need to bypass the cache:
   ```bash    
   docker build --no-cache -t yourhubuser/your-api:latest .

3. **Verify if the image exists:**  
   ```bash
   docker images | grep your-api

### 2. Deploying & Managing with Docker Compose

1. We use Docker Compose to run both the API and its PostgreSQL database together.

    Install Docker Compose (if you haven’t already):
```bash
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
```
2. Start the environment:
```bash
   docker-compose up -d --build
```
    -d runs containers in the background.

    --build ensures images are rebuilt if you’ve changed code or the Dockerfile.

3. Check status:
```bash
   docker-compose ps
```
You should see both api and db services listed as “Up.”

4. View real-time logs:
```bash
   docker-compose logs -f api
```
Replace 'api' with 'db' to see database logs.

5. Stopping & removing containers:
```bash
   docker-compose down
```
    To remove named volumes (e.g., reset your database):
```bash
   docker-compose down -v
```
6. Rebuild or scale a single service:
```bash
    # Rebuild only the API
    docker-compose up -d --build api

    # Run multiple API instances
    docker-compose up -d --scale api=3
```
### 3. Troubleshooting Tips

1. Permission denied while connecting to /var/run/docker.sock
    → Add your user to the docker group and log out/in:
```bash
   sudo usermod -aG docker $USER
   newgrp docker
```
2. ImportError: No module named 'flask_sqlalchemy'
→ Make sure your requirements.txt lists Flask-SQLAlchemy and rebuild the image without cache:
```bash
   docker-compose build --no-cache api
```
3. Connection refused to Postgres at localhost:5432
→ In Compose, use the database service name as host. e.g.
```yaml
environment:
  DATABASE_URL: postgres://myuser:mypass@db:5432/mydb
```
and in your app read DATABASE_URL from os.environ.

4. Container exits immediately after up
→ Inspect its logs for the startup error:
```bash
   docker-compose logs api
```
5. Stale cache preventing changes from applying
→ Remove dangling images and prune build cache:
```bash
   docker system prune --all --volumes
   docker-compose up --build
```
6. Data missing after down && up
→ Ensure your database volume is declared in docker-compose.yml under volumes: and not removed without -v. 

### The Docker url repository
https://hub.docker.com/repositories/alaxcole

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

