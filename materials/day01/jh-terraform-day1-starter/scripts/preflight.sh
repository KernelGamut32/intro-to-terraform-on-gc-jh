#!/usr/bin/env bash
# Day 1 preflight: confirm tools, identity, project, and APIs before L01.
# Usage: scripts/preflight.sh LAB_PROJECT_ID
# Writes an evidence file under evidence/ that you keep for the M02 check.
set -uo pipefail

PROJECT_ID="${1:-}"
if [[ -z "$PROJECT_ID" ]]; then
  echo "Usage: scripts/preflight.sh LAB_PROJECT_ID" >&2
  exit 2
fi

mkdir -p evidence
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT="evidence/preflight-${STAMP}.txt"
PASS=0
FAIL=0

say()  { printf '%s\n' "$*" | tee -a "$OUT"; }
ok()   { PASS=$((PASS+1)); say "  [PASS] $*"; }
bad()  { FAIL=$((FAIL+1)); say "  [FAIL] $*"; }

say "Day 1 preflight evidence"
say "Generated (UTC): ${STAMP}"
say "Intended lab project: ${PROJECT_ID}"
say ""

say "1. Tool versions"
if command -v terraform >/dev/null 2>&1; then
  TFV="$(terraform version -json 2>/dev/null | jq -r '.terraform_version' 2>/dev/null || terraform version | head -1)"
  say "  terraform: ${TFV}"
  MAJOR="${TFV%%.*}"; REST="${TFV#*.}"; MINOR="${REST%%.*}"
  if [[ "$MAJOR" -ge 1 && "$MINOR" -ge 11 ]]; then ok "Terraform ${TFV} satisfies >= 1.11"; else bad "Terraform ${TFV} is older than 1.11"; fi
else
  bad "terraform not found on PATH"
fi
if command -v gcloud >/dev/null 2>&1; then ok "gcloud $(gcloud version 2>/dev/null | head -1)"; else bad "gcloud not found on PATH"; fi
if command -v jq >/dev/null 2>&1; then ok "jq $(jq --version)"; else bad "jq not found on PATH (required by inventory.sh)"; fi
if command -v git >/dev/null 2>&1; then ok "git $(git --version | awk '{print $3}')"; else bad "git not found on PATH"; fi
say ""

say "2. Identity"
ACCOUNT="$(gcloud auth list --filter=status:ACTIVE --format='value(account)' 2>/dev/null)"
if [[ -n "$ACCOUNT" ]]; then ok "Active gcloud account: ${ACCOUNT}"; else bad "No active gcloud account. Run: gcloud auth login"; fi
if gcloud auth application-default print-access-token >/dev/null 2>&1; then
  ok "Application Default Credentials can mint a token"
else
  bad "ADC not configured. Run: gcloud auth application-default login"
fi
say ""

say "3. Project"
CFG_PROJECT="$(gcloud config get-value project 2>/dev/null)"
say "  gcloud configured project: ${CFG_PROJECT:-<none>}"
if [[ "$CFG_PROJECT" == "$PROJECT_ID" ]]; then
  ok "gcloud project matches the intended lab project"
else
  bad "gcloud project does not match. Run: gcloud config set project ${PROJECT_ID}"
fi
if gcloud projects describe "$PROJECT_ID" --format='value(projectId)' >/dev/null 2>&1; then
  ok "Project ${PROJECT_ID} is reachable with this identity"
else
  bad "Cannot describe ${PROJECT_ID}. Check the project ID and your access."
fi
say ""

say "4. Required APIs"
ENABLED="$(gcloud services list --enabled --project "$PROJECT_ID" --format='value(config.name)' 2>/dev/null)"
for API in compute.googleapis.com iam.googleapis.com iap.googleapis.com storage.googleapis.com secretmanager.googleapis.com; do
  if grep -qx "$API" <<<"$ENABLED"; then ok "$API enabled"; else bad "$API not enabled (ask the instructor)"; fi
done
say ""

say "5. Working directory"
if [[ -f labs/L01-build-and-parameterize/versions.tf ]]; then ok "Repository layout found"; else bad "Run this script from the repository root"; fi
say ""

say "Summary: ${PASS} passed, ${FAIL} failed"
say "Evidence file: ${OUT}"
if [[ "$FAIL" -gt 0 ]]; then exit 1; fi
