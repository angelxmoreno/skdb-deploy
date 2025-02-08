#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Updating skdb-deploy (Docker configuration)..."
cd "$SCRIPT_DIR" || exit 1

# Load environment variables if .env exists
if [ -f .env ]; then
    echo "🔄 Loading environment variables from .env..."
    export $(grep -v '^#' .env | xargs)
fi

# Pull latest changes from GitHub
git pull origin main || { echo "❌ Failed to pull latest changes!"; exit 1; }

# Restart the Docker containers
echo "🔄 Restarting containers..."
docker-compose down
docker-compose up -d --build || { echo "❌ Failed to start containers!"; exit 1; }

# ✅ Wait for PHP-FPM to be ready before restarting Nginx
echo "⏳ Waiting for PHP-FPM to be ready..."
sleep 5  # Small delay

# Restart Nginx separately to ensure it can connect to PHP-FPM
echo "♻️ Restarting Nginx..."
docker-compose restart nginx_app || { echo "❌ Failed to restart Nginx APP!"; exit 1; }
docker-compose restart nginx_fe || { echo "❌ Failed to restart Nginx FE!"; exit 1; }

# Cleanup old Docker images
echo "🧹 Cleaning up unused Docker images..."
docker image prune -f

echo "✅ skdb-deploy update complete!"
