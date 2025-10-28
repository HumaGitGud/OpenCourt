# Deployment (Docker Compose)

This project includes Docker configuration to run the backend and database locally using Docker Compose.

## Files of interest

- `docker-compose.yml` - builds and runs the `backend` and `db` services locally
- `src/server/Dockerfile` - Node/Express backend image
- `src/database/Dockerfile` - MySQL image that copies the SQL init scripts
- `template.env` - template for environment variables (copy to `.env` at repo root)

## Quick start on a VM

1. Install Docker and Docker Compose on the VM
2. Clone this repository and cd into the project root
3. Create a `.env` from the provided `template.env` and edit values:

Example `.env` (do NOT commit this file if it contains secrets):

```
DB_HOST=db
DB_USER=opencourt_user
DB_PASSWORD=opencourt_password
DB_NAME=opencourt
DB_PORT=3306
```

Note: `DB_HOST` is used by apps outside Docker; inside the compose network the backend connects to the service name `db` (docker-compose sets `DB_HOST=db` for the backend automatically).

4. Make the deploy script executable and run it:

```bash
chmod +x deploy.sh
./deploy.sh
```

5. Verify services

- Backend: http://<vm-ip>:3000
- MySQL: connect to <vm-ip>:<DB_PORT>

## Troubleshooting

- If the backend logs show `Waiting for DB...` this is normal while MySQL initializes the database and applies the scripts; wait a minute and check logs again:

```bash
docker-compose logs -f backend
docker-compose logs -f db
```

- If MySQL fails to start, inspect the DB logs for SQL errors or permission problems:

```bash
docker-compose logs db
```

- Ensure `.env` is at the repository root (the backend code expects `../../../.env` from `src/server/model/db.js`).

## Notes

- The compose setup builds images locally, so you do not need a container registry. This works well for VMs where you control the repository and can run builds on the host.
- For production deployments, consider pushing images to a registry and using a process manager or orchestration platform.
