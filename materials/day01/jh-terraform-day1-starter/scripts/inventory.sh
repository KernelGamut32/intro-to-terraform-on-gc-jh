#!/usr/bin/env bash
# Builds a small, non-secret inventory report from Terraform outputs.
# Run from a lab root directory after terraform apply.
# Usage: ../../scripts/inventory.sh [environment]
set -euo pipefail

ENVIRONMENT="${1:-dev}"
mkdir -p inventory
JSON="inventory/${ENVIRONMENT}.json"
MD="inventory/${ENVIRONMENT}.md"

# terraform output -json is the machine-readable form of every output.
terraform output -json > "$JSON"

if ! jq -e '.inventory' "$JSON" >/dev/null 2>&1; then
  echo "No 'inventory' output found yet. Add it in M04 and rerun." >&2
  exit 1
fi

{
  echo "# ledgerlite inventory (${ENVIRONMENT})"
  echo ""
  echo "Generated (UTC): $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo ""
  echo "| Field | Value |"
  echo "| --- | --- |"
  jq -r '.inventory.value | to_entries[] | "| \(.key) | \(.value) |"' "$JSON"
} > "$MD"

echo "Wrote ${JSON} and ${MD}"
cat "$MD"
