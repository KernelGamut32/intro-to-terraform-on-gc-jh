#!/usr/bin/env bash
# Prepares one learner lab project for Day 1.
#
# Usage: provision-lab-project.sh PROJECT_ID LEARNER_EMAIL BUCKET_NAME [LOCATION]
# Example:
#   provision-lab-project.sh jh-tf-lab-07 learner07@jhlabs.example jh-tf-state-lab-07-4f2a US
#
# Run with an identity that holds Owner on the project. Billing must already
# be linked. Safe to rerun: every step is idempotent or tolerates "already exists".
set -euo pipefail

PROJECT_ID="${1:?PROJECT_ID required}"
LEARNER="${2:?LEARNER_EMAIL required}"
BUCKET="${3:?BUCKET_NAME required}"
LOCATION="${4:-US}"
HERE="$(cd "$(dirname "$0")" && pwd)"
APP_SA="ledgerlite-app@${PROJECT_ID}.iam.gserviceaccount.com"

echo "==> Enabling APIs"
gcloud services enable \
  compute.googleapis.com \
  iam.googleapis.com \
  iap.googleapis.com \
  storage.googleapis.com \
  secretmanager.googleapis.com \
  --project="${PROJECT_ID}"

echo "==> Creating the runtime service account (attached to the instance)"
if ! gcloud iam service-accounts describe "${APP_SA}" --project="${PROJECT_ID}" >/dev/null 2>&1; then
  gcloud iam service-accounts create ledgerlite-app \
    --project="${PROJECT_ID}" \
    --display-name="ledgerlite runtime identity"
fi

echo "==> Granting the learner least-privilege project roles"
# The learner is the Terraform runner on Day 1. These match the M06 slide:
#   networkAdmin (VPC, subnet), securityAdmin (firewall rule only),
#   instanceAdmin.v1 (instance, disk).
# Added for the lab experience:
#   iap.tunnelResourceAccessor (verify through IAP), compute.osAdminLogin
#   (if OS Login is enforced by org policy), serviceusage.serviceUsageConsumer
#   (ADC quota project), compute.viewer (console browsing).
for ROLE in \
  roles/compute.networkAdmin \
  roles/compute.securityAdmin \
  roles/compute.instanceAdmin.v1 \
  roles/compute.viewer \
  roles/iap.tunnelResourceAccessor \
  roles/compute.osAdminLogin \
  roles/serviceusage.serviceUsageConsumer; do
  gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="user:${LEARNER}" --role="${ROLE}" --condition=None --quiet >/dev/null
  echo "    ${ROLE}"
done

echo "==> Letting the learner attach the runtime identity (scoped to that one account)"
gcloud iam service-accounts add-iam-policy-binding "${APP_SA}" \
  --project="${PROJECT_ID}" \
  --member="user:${LEARNER}" \
  --role="roles/iam.serviceAccountUser" --quiet >/dev/null

echo "==> Bootstrapping the state bucket"
if gcloud storage buckets describe "gs://${BUCKET}" >/dev/null 2>&1; then
  echo "    bucket exists; ensuring versioning and access"
  gcloud storage buckets update "gs://${BUCKET}" --versioning
  gcloud storage buckets add-iam-policy-binding "gs://${BUCKET}" \
    --member="user:${LEARNER}" --role="roles/storage.objectAdmin" >/dev/null
else
  "${HERE}/bootstrap-backend.sh" "${PROJECT_ID}" "${BUCKET}" "${LOCATION}" "user:${LEARNER}"
fi

echo "==> Summary for the roster"
echo "project_id=${PROJECT_ID}"
echo "learner=${LEARNER}"
echo "app_service_account_email=${APP_SA}"
echo "state_bucket=${BUCKET}"
echo "state_prefix=labs/${PROJECT_ID#jh-tf-}"
