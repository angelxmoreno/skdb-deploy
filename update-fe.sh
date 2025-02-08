#!/bin/bash
# update-fe.sh
# This script updates the SKDB Frontend.
# It performs the following steps:
#   1. Loads environment variables from .env.
#   2. Runs the fe_builder service (as a one-off container) to:
#         - Pull the latest FE code.
#         - Install dependencies.
#         - Build the FE app.
#         - Copy the built files (from /src/dist) into /app (the mounted volume).
#   3. Restarts the nginx_fe container to serve the updated assets.

# Get the directory where the script is located.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Updating skdb-fe (Frontend)..."

# Load environment variables if .env exists.
if [ -f "$SCRIPT_DIR/.env" ]; then
    echo "🔄 Loading environment variables from .env..."
    export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs)
fi

# Run the fe_builder service to build the FE app and update the shared volume.
echo "🔄 Building FE using fe_builder..."
docker-compose run --rm fe_builder || { echo "❌ FE build failed!"; exit 1; }

# Restart the nginx_fe container so it serves the updated FE assets.
echo "♻️ Restarting nginx_fe container..."
docker-compose restart nginx_fe || { echo "❌ Failed to restart FE nginx container!"; exit 1; }

echo "✅ skdb-fe update complete!"
