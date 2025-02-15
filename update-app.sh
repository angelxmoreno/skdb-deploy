#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Updating skdb-be (Application Code)..."

# Load environment variables if .env exists
if [ -f "$SCRIPT_DIR/.env" ]; then
    echo "🔄 Loading environment variables from .env..."
    export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs)
fi

# Ensure the PHP container is running
if ! docker ps | grep -q "skdb_php"; then
    echo "❌ PHP container (skdb_php) is not running!"
    exit 1
fi

# Configure Git credentials inside the container
echo "🔑 Configuring Git credentials inside the container..."
docker exec skdb_php git config --global credential.helper store
docker exec skdb_php sh -c "echo 'https://${GITHUB_USERNAME}:${GITHUB_ACCESS_TOKEN}@github.com' > ~/.git-credentials"

# ✅ Fix: Mark the repo directory as safe
echo "🛠 Marking /var/www/html as a safe directory..."
docker exec skdb_php git config --global --add safe.directory /var/www/html

# Pull the latest code inside the container
echo "🔄 Pulling latest changes inside the container..."
docker exec skdb_php git -C /var/www/html pull origin main || { echo "❌ Git pull failed!"; exit 1; }

# Install dependencies inside the container (WITH DEV DEPENDENCIES)
echo "📦 Installing PHP dependencies (including dev)..."
docker exec skdb_php composer install --optimize-autoloader || { echo "❌ Composer install failed!"; exit 1; }

# Run database migrations
echo "🔄 Running database migrations..."
docker exec skdb_php bin/cake run_migrations || { echo "❌ Migrations failed!"; exit 1; }

# Run all database seeds
echo "🌱 Seeding database..."
docker exec skdb_php bin/cake migrations seed || { echo "❌ Seeding failed!"; exit 1; }

# Restart PHP container to apply changes
echo "♻️ Restarting PHP container..."
docker-compose restart php || { echo "❌ Failed to restart PHP container!"; exit 1; }

echo "✅ skdb-be update complete!"
