#!/bin/bash

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    cp template.env .env
    echo "Created .env file from template. Please edit it with your configuration."
    exit 1
fi


# Build images locally and start services
echo "Building images locally and starting services..."
docker-compose up --build -d

echo "Deployment complete! Services should be running at:"
echo "Backend: http://localhost:3000"
echo "Database: localhost:3306"