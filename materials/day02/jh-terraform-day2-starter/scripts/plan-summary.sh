#!/usr/bin/env bash
# Turns a saved plan into a short review table. It reads the plan as data,
# so the same summary can feed a change record or an audit.
#
# Usage (from any root configuration, after terraform plan -out=FILE):
#   ../../scripts/plan-summary.sh FILE
#
# A saved plan can contain sensitive values. Treat the plan file and any
# JSON you derive from it with the same care as state. This script prints
# addresses, actions, and locations only.
set -euo pipefail

PLAN="${1:?Usage: plan-summary.sh PLANFILE}"
if [[ ! -f "$PLAN" ]]; then
  echo "Plan file not found: ${PLAN}" >&2
  exit 2
fi

JSON="$(terraform show -json "$PLAN")"

echo "Plan summary for ${PLAN}"
echo "Workspace: $(terraform workspace show)"
echo ""

TABLE="$(jq -r '
  def place: (.change.after.zone // .change.after.region // .change.before.zone // .change.before.region // "global");
  ["ACTION", "ADDRESS", "LOCATION", "NOTE"],
  ( .resource_changes // []
    | map(select(.mode == "managed"))
    | map(select(.change.actions != ["no-op"] or .previous_address != null or .change.importing != null))
    | .[]
    | [ (if .change.importing != null and .change.actions == ["no-op"] then "import"
         elif .previous_address != null and .change.actions == ["no-op"] then "move"
         elif .change.actions == ["delete", "create"] or .change.actions == ["create", "delete"] then "replace"
         else (.change.actions | join("+")) end),
        .address,
        (place | tostring | split("/") | last),
        (if .previous_address != null then "moved from " + .previous_address
         elif .change.importing != null then "import id " + (.change.importing.id // "by identity")
         elif .action_reason != null then .action_reason
         else "" end) ]
  ) | @tsv' <<<"$JSON")"

if command -v column >/dev/null 2>&1; then
  column -t -s $'\t' <<<"$TABLE"
else
  printf '%s\n' "$TABLE"
fi

echo ""
jq -r '
  (.resource_changes // [] | map(select(.mode == "managed"))) as $rc
  | "Totals: \($rc | map(select(.change.actions == ["create"])) | length) to add, "
  + "\($rc | map(select(.change.actions == ["update"])) | length) to change, "
  + "\($rc | map(select(.change.actions == ["delete"])) | length) to destroy, "
  + "\($rc | map(select(.change.actions | length == 2)) | length) to replace, "
  + "\($rc | map(select(.change.importing != null)) | length) to import, "
  + "\($rc | map(select(.previous_address != null)) | length) moved"' <<<"$JSON"
