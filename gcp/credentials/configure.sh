#!/bin/sh

echo ${GCP_SERVICE_KEY} | base64 -d | gcloud auth activate-service-account --key-file=-
gcloud --quiet config set project ${GCP_PROJECT_ID} 2>/dev/null
echo "GCP CLI configured with project ${GCP_PROJECT_ID}"