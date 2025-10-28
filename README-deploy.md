# OpenCourt Docker Deployment

This project uses Docker Compose to run three containerized services:
- Frontend (React/Vite app served by nginx)
- Backend (Node.js/Express API)
- Database (MySQL)

## Files of interest

```
docker-compose.yml              # Main compose configuration for all services
src/
  frontend/opencourt/
    Dockerfile                  # Multi-stage build for React app + nginx
    nginx.conf                  # Nginx config with API proxy rules
  server/
    Dockerfile                  # Node.js backend image
  database/
    Dockerfile                  # MySQL image with init scripts
template.env                    # Template for environment variables
```

## Prerequisites

1. Docker Engine installed
2. Docker Compose v2 installed
3. Git (to clone the repository)

## Deployment Steps

1. Clone and enter the repository:
```bash
git clone https://github.com/HumaGitGud/OpenCourt.git
cd OpenCourt
```

2. Create and configure environment file:
```bash
cp template.env .env
```

Edit `.env` with your database credentials. Example content:
```
DB_HOST=db
DB_USER=opencourt_user
DB_PASSWORD=opencourt_password
DB_NAME=opencourt
DB_PORT=3306
```

Note: Inside Docker Compose, services can reach each other by service name. The backend automatically uses `db` as the database host.

3. Make the deployment script executable:
```bash
chmod +x ./deploy.sh
```

4. Build and start all services:
```bash
./deploy.sh
```

The script runs `docker-compose up --build -d` to build fresh images and start containers in detached mode.

## Accessing the Application

Once deployed, the services are available at:

- Frontend (Web UI): `http://<vm-ip>:5173`
- Backend API: `http://<vm-ip>:3000`
- Database: `<vm-ip>:<DB_PORT>` (from template.env)

The frontend nginx server proxies API requests to the backend, so everything works through the frontend URL.

## Troubleshooting

### View Logs

Check service logs in real-time:
- All services: `docker-compose logs -f`
- Specific service: `docker-compose logs -f [service]`
  ```bash
  docker-compose logs -f frontend  # Frontend/nginx logs
  docker-compose logs -f backend   # Node.js API logs
  docker-compose logs -f db        # MySQL logs
  ```

### Common Issues

1. **Backend shows "Waiting for DB..."**
   - Normal during startup while MySQL initializes
   - Wait a minute and check logs again
   - If persistent, verify DB credentials in `.env`

2. **Frontend can't reach API**
   - Check nginx proxy logs: `docker-compose logs frontend`
   - Verify backend is running: `docker-compose ps`
   - Test backend directly: `curl http://localhost:3000/users`

3. **Database fails to start**
   - Check MySQL logs for permission/initialization errors
   - Verify DB_ variables in `.env`
   - Try removing the volume and rebuilding:
     ```bash
     docker-compose down -v
     docker-compose up --build
     ```

## Architecture Notes

- **Local Builds**: All images are built locally on the VM—no container registry needed
- **Frontend**: 
  - Built with Vite during docker build
  - Served by nginx on port 5173
  - Uses same-origin requests for API calls
  - Nginx proxies `/games`, `/locations`, `/users` to backend
- **Backend**:
  - Node.js/Express API on port 3000
  - Waits for DB availability before starting
  - Uses environment variables for configuration
- **Database**:
  - MySQL 8.0 with initialization scripts
  - Data persisted in named volume `mysql-data`
  - Auto-creates schema and tables on first run

## Stopping Services

Stop and remove containers while preserving data:
```bash
docker-compose down
```

Complete cleanup (including database volume):
```bash
docker-compose down -v
```