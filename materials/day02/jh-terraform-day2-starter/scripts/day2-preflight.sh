#!/usr/bin/env bash
# Day 2 start check: confirm you are starting from a clean deployment.
# Run it from the ledgerlite root:
#   cd labs/L01-build-and-parameterize
#   ../../scripts/day2-preflight.sh
# Writes an evidence file under evidence/ that you keep for the M07 check.
set -uo pipefail

mkdir -p evidence
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT="evidence/day2-start-${STAMP}.txt"
PLAN_OUT="evidence/day2-start-plan-${STAMP}.txt"
PASS=0
FAIL=0
WARN=0

say()  { printf '%s\n' "$*" | tee -a "$OUT"; }
ok()   { PASS=$((PASS+1)); say "  [PASS] $*"; }
bad()  { FAIL=$((FAIL+1)); say "  [FAIL] $*"; }
warn() { WARN=$((WARN+1)); say "  [WARN] $*"; }

say "Day 2 start check"
say "Generated (UTC): ${STAMP}"
say "Directory: $(pwd)"
say ""

say "1. Location"
if [[ -f versions.tf && -f main.tf && -f variables.tf ]]; then
  ok "Root configuration files found"
else
  bad "Run this script from labs/L01-build-and-parameterize (the ledgerlite root)"
fi
if [[ -f backend.tf ]]; then
  ok "backend.tf present (added in L02)"
else
  bad "backend.tf is missing. Ask for the Day 1 M05 checkpoint before continuing"
fi
if [[ -d .terraform ]]; then
  ok "Working directory is initialized"
else
  bad "Run terraform init first"
fi
say ""

say "2. Tools"
if command -v terraform >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  TFV="$(terraform version -json 2>/dev/null | jq -r '.terraform_version')"
  MAJOR="${TFV%%.*}"; REST="${TFV#*.}"; MINOR="${REST%%.*}"
  # Guard the arithmetic below against an unreadable version string.
  if ! [[ "$MAJOR" =~ ^[0-9]+$ && "$MINOR" =~ ^[0-9]+$ ]]; then MAJOR=0; MINOR=0; fi
  if (( MAJOR > 1 || (MAJOR == 1 && MINOR >= 11) )); then
    ok "Terraform ${TFV} satisfies >= 1.11"
  else
    bad "Terraform ${TFV} is older than 1.11"
  fi
  if (( MAJOR > 1 || (MAJOR == 1 && MINOR >= 16) )); then
    say "         Optional callouts that need 1.16 or later are available to you"
  else
    say "         Optional callouts that need 1.16 or later are not available; the lab steps are unaffected"
  fi
  PROV="$(terraform version -json 2>/dev/null | jq -r '.provider_selections["registry.terraform.io/hashicorp/google"] // "not selected"')"
  say "         hashicorp/google provider: ${PROV}"
else
  bad "terraform and jq must both be on PATH"
fi
say ""

say "3. Backend and workspace"
BACKEND_TYPE="$(jq -r '.backend.type // "local"' .terraform/terraform.tfstate 2>/dev/null || echo unknown)"
if [[ "$BACKEND_TYPE" == "gcs" ]]; then
  BUCKET="$(jq -r '.backend.config.bucket' .terraform/terraform.tfstate)"
  PREFIX="$(jq -r '.backend.config.prefix' .terraform/terraform.tfstate)"
  ok "Backend is gcs: gs://${BUCKET}/${PREFIX}"
else
  bad "Backend is '${BACKEND_TYPE}', expected gcs. Finish L02 or ask for the M05 checkpoint"
fi
WS="$(terraform workspace show 2>/dev/null || echo unknown)"
if [[ "$WS" == "default" ]]; then
  ok "Selected workspace: default"
else
  bad "Selected workspace is '${WS}'. Run: terraform workspace select default"
fi
say ""

say "4. State"
ADDRESSES="$(terraform state list 2>/dev/null || true)"
COUNT="$(printf '%s\n' "$ADDRESSES" | grep -c . || true)"
say "  Addresses in state: ${COUNT}"
printf '%s\n' "$ADDRESSES" | sed 's/^/    /' | tee -a "$OUT" >/dev/null
for ADDR in google_compute_network.main google_compute_subnetwork.app google_compute_firewall.allow_iap google_compute_instance.app; do
  if grep -qx "$ADDR" <<<"$ADDRESSES"; then
    ok "${ADDR} is in state"
  else
    bad "${ADDR} is not in state"
  fi
done
say ""

say "5. Clean plan"
terraform plan -detailed-exitcode -input=false -no-color >"$PLAN_OUT" 2>&1
RC=$?
case "$RC" in
  0)
    ok "No changes. Your infrastructure matches the configuration"
    ;;
  2)
    warn "The plan proposes changes. Read ${PLAN_OUT} before you continue"
    say "         Most likely cause: a newer debian-13 image was published since your last apply,"
    say "         so the instance shows '-/+ must be replaced'. That is the cost of following an"
    say "         image family. Tell the instructor, apply the plan, and rerun this script."
    ;;
  *)
    bad "terraform plan failed. Read ${PLAN_OUT}"
    ;;
esac
say ""

say "Summary: ${PASS} passed, ${WARN} warnings, ${FAIL} failed"
say "Evidence file: ${OUT}"
if [[ "$FAIL" -gt 0 ]]; then exit 1; fi
