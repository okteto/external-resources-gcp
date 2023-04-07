#!/bin/sh

bucketName="${OKTETO_NAMESPACE}-oktacoshop"
deleteBucket=$(gcloud storage rm --recursive gs://${bucketName} 2>/dev/null)
exitCode=$?
if [ $exitCode -eq 0 ]; then
  echo "bucket deleted successfully"
  exit 0
fi

echo "$deleteBucket" | grep -q "not found" 
if [ $? -eq 1 ]; then
    echo "bucket deleted successfully"
    exit 0
fi

echo "Failed to delete bucket: $deleteBucket"
exit 1