#!/bin/sh

bucket="${OKTETO_NAMESPACE}-oktacoshop"
createBucket=$(gcloud storage buckets create "gs://${bucket}" 2>/dev/null)
exitCode=$?

if [ $exitCode -ne 0 ]; then
  echo "$createBucket" | grep -q "Resource already exists in the project" 
  if [ $? -eq 1 ]; then
    echo "Bucket $bucket already exists"
  else
    echo "Failed to create bucket: $createBucket"
    exit 1
  fi
fi

{
  echo "OKTETO_EXTERNAL_PUBSUB_ENDPOINTS_TOPIC_URL=https://console.cloud.google.com/storage/browser/${bucket}"
  echo "STORAGE_BUCKET_NAME=$bucket"
} >> "$OKTETO_ENV"

echo "Storage configuration generated successfully"
exit 0