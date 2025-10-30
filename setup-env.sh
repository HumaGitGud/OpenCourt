#!/bin/bash

# Exit on any error
set -e

# Configuration
ENV_FILE=.env
ENV_TEMPLATE=template.env
VAULT_DIR=/opt/opencourt/secrets
BACKUP_DIR=/var/backups/opencourt

# Create necessary directories
sudo mkdir -p "$VAULT_DIR"
sudo mkdir -p "$BACKUP_DIR"
sudo chown -R $USER:$USER "$VAULT_DIR"

# Generate secure database password
DB_PASSWORD=$(openssl rand -base64 32)

# Generate environment file from template
if [ ! -f "$ENV_FILE" ]; then
    if [ -f "$ENV_TEMPLATE" ]; then
        echo "Creating .env from template..."
        cp "$ENV_TEMPLATE" "$ENV_FILE"
        
        # Set secure values
        sed -i "s/^DB_HOST=.*/DB_HOST=db/" "$ENV_FILE"
        sed -i "s/^DB_USER=.*/DB_USER=opencourt_user/" "$ENV_FILE"
        sed -i "s/^DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/" "$ENV_FILE"
        sed -i "s/^DB_NAME=.*/DB_NAME=opencourt/" "$ENV_FILE"
        sed -i "s/^DB_PORT=.*/DB_PORT=3306/" "$ENV_FILE"
        
        # Backup environment to secure location
        sudo cp "$ENV_FILE" "$VAULT_DIR/"
        sudo chmod 600 "$VAULT_DIR/$ENV_FILE"
        
        echo "Environment file created and secured."
        echo "Credentials backed up to $VAULT_DIR/$ENV_FILE"
    else
        echo "Error: template.env not found!"
        exit 1
    fi
else
    echo "Warning: .env already exists. Skipping creation."
    echo "If you need to recreate it, remove the existing file first."
fi

# Create backup script if it doesn't exist
if [ ! -f "backup.sh" ]; then
    cat > backup.sh << 'EOL'
#!/bin/bash
BACKUP_DIR=/var/backups/opencourt
VAULT_DIR=/opt/opencourt/secrets
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Stop services
docker-compose down

# Backup MySQL data
docker run --rm \
    -v opencourt_mysql-data:/data \
    -v "$BACKUP_DIR:/backup" \
    alpine tar czf "/backup/mysql_${DATE}.tar.gz" /data

# Backup environment
sudo cp "$VAULT_DIR/.env" "$BACKUP_DIR/env_${DATE}.bak"

# Restart services
docker-compose up -d

# Keep only last 7 days of backups
find "$BACKUP_DIR" -name "mysql_*.tar.gz" -mtime +7 -delete
find "$BACKUP_DIR" -name "env_*.bak" -mtime +7 -delete

echo "Backup completed: $BACKUP_DIR/mysql_${DATE}.tar.gz"
EOL

    chmod +x backup.sh
    echo "Backup script created."
fi

echo "Environment setup complete!"
echo "Please review the .env file and adjust any settings if needed."