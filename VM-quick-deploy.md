# Quick VM Deployment

Simple guide to deploy OpenCourt after cloning the repository.

## Prerequisites
- Docker and Docker Compose already installed on VM
- Git installed

## Deployment Steps

1. Clone the repository on your VM:
```bash
git clone https://github.com/HumaGitGud/OpenCourt.git
cd OpenCourt
```

2. Create and configure `.env` file:
```bash
cp template.env .env
```

Edit `.env` with your database settings:
```
DB_HOST=db
DB_USER=your_db_user
DB_PASSWORD=your_secure_password
DB_NAME=opencourt
DB_PORT=3306
```

3. Build and start the containers:
```bash
docker-compose up --build -d
```

## Verify Services

Check if containers are running:
```bash
docker-compose ps
```

Check logs if needed:
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs frontend
docker-compose logs backend
docker-compose logs db
```

## Access the Application

Once deployed, access the application at:
- Frontend: `http://<vm-ip>:5173`
- Backend API: `http://<vm-ip>:3000`

## Basic Management

Stop the application:
```bash
docker-compose down
```

Restart the application:
```bash
docker-compose up -d
```

View real-time logs:
```bash
docker-compose logs -f
```

## Troubleshooting

If the frontend can't reach the backend:
1. Check if all containers are running:
```bash
docker-compose ps
```

2. Verify the backend is responding:
```bash
curl http://localhost:3000/users
```

3. Check container logs for errors:
```bash
docker-compose logs
```

If database fails to start:
1. Check environment variables in `.env`
2. Verify MySQL logs:
```bash
docker-compose logs db
```