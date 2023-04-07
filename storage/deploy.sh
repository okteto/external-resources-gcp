#!/bin/sh

bucket="${OKTETO_NAMESPACE}-oktacoshop"
createBucket=$(gcloud storage buckets create "gs://${bucket}")
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






#!/bin/sh

bucketName="${OKTETO_NAMESPACE}-oktacoshop"
output=$(aws s3 mb "s3://$bucketName")
exitCode=$?

if [ $exitCode -ne 0 ]; then
  echo "$output" | grep -q "BucketAlreadyOwnedByYou" 
  if [ $? -eq 1 ]; then
    echo "S3 bucket already exists"
  else
    echo "Failed to create S3: exit code $exitCode"
    exit $exitCode
  fi
fi

if [ $exitCode -eq 0 ]; then
  echo "S3 bucket created successfully"
fi

dashboard="https://s3.console.aws.amazon.com/s3/buckets/$bucketName"

{
  echo "OKTETO_EXTERNAL_S3_ENDPOINTS_BUCKET_URL=$dashboard"
  echo "S3_BUCKET_NAME=$bucketName"
}  >> "$OKTETO_ENV"

 
echo "S3 bucket configuration generated successfully"
exit 0


