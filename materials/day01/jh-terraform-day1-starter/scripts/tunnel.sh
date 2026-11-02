#!/usr/bin/env bash
# Opens an IAP TCP forwarding tunnel to the ledgerlite app port and prints
# the local URL. Requires roles/iap.tunnelResourceAccessor on the project.
# Usage: ../../scripts/tunnel.sh   (run from a lab root after apply)
set -euo pipefail

NAME="$(terraform output -raw instance_name)"
ZONE="$(terraform output -raw instance_zone)"
PORT="$(terraform output -raw app_port 2>/dev/null || echo 8080)"
PROJECT="$(terraform output -raw project_id 2>/dev/null || gcloud config get-value project)"

echo "Opening IAP tunnel to ${NAME}:${PORT} in ${ZONE} (${PROJECT})"
echo "When the tunnel reports 'Listening on port', open http://localhost:${PORT} in your browser."
echo "Press Ctrl+C to close the tunnel."
gcloud compute start-iap-tunnel "$NAME" "$PORT" \
  --local-host-port="localhost:${PORT}" \
  --zone "$ZONE" \
  --project "$PROJECT"
