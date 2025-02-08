#!/bin/bash
# update-fe.sh
# This script updates the SKDB Frontend by:
#   1. Loading environment variables.
#   2. Executing update commands inside the persistent fe_builder container:
#         - Pull the latest FE code.
#         - Run bun install.
#         - Run bun run build.
#         - Copy the new build output from /src/dist to /public.
#   3. Restarting the nginx_fe container so it serves the updated assets.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Updating skdb-fe (Frontend)..."

if [ -f "$SCRIPT_DIR/.env" ]; then
    echo "🔄 Loading environment variables from .env..."
    export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs)
fi

# Execute update commands in the persistent fe_builder container
echo "🔄 Executing update commands inside fe_builder..."
docker exec skdb_fe_builder sh -c "cd /src && git pull origin main && bun install && bun run build && cp -r /src/dist/* /public/"

# Restart the nginx_fe container to serve the updated assets
echo "♻️ Restarting nginx_fe container..."
docker-compose restart nginx_fe || { echo "❌ Failed to restart FE nginx container!"; exit 1; }

echo "✅ skdb-fe update complete!"
