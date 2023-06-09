#!/bin/sh

topic="${OKTETO_NAMESPACE}-oktacoshop-gcp"
createTopic=$(gcloud pubsub topics create "$topic" 2>/dev/null)
exitCode=$?

if [ $exitCode -ne 0 ]; then
  echo "$createTopic" | grep -q "Resource already exists in the project" 
  if [ $? -eq 1 ]; then
    echo "Topic $topic already exists"
  else
    echo "Failed to create topic: $createTopic"
    exit 1
  fi
fi

subscription="${topic}-sub"
createSubscription=$(gcloud pubsub subscriptions create "$subscription" --topic="$topic" 2>/dev/null)
exitCode=$?
if [ $exitCode -ne 0 ]; then
  echo "$createSubscription" | grep -q "Resource already exists in the project" 
  if [ $? -eq 1 ]; then
    echo "Subscription $subscription already exists"
  else
    echo "Failed to create subscription: $createSubscription"
    exit 1
  fi
fi

dashboardUrl="https://console.cloud.google.com/cloudpubsub/topic/detail/${topic}?project=${GCP_PROJECT_ID}"

{
  echo "OKTETO_EXTERNAL_PUBSUB_ENDPOINTS_TOPIC_URL=$dashboardUrl"
  echo "PUBSUB_TOPIC_NAME=$topic"
  echo "PUBSUB_SUBSCRIPTION_NAME=$subscription"
} >> "$OKTETO_ENV"

echo "PUB/SUB configuration generated successfully"
exit 0


