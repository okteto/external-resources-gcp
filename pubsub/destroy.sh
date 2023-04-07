#!/bin/sh

subscription="${topic}-sub"
deleteSubscription=$(gcloud pubsub subscriptions delete "$subscription" --topic="$topic")
exitCode=$?

if [ $exitCode -ne 0 ]; then
  echo "$deleteSubscription" | grep -q "Resource doesn't exist in the project" 
  if [ $? -eq 0 ]; then
    echo "Failed to delete subscription: $deleteSubscription"
    exit 1
  fi
fi

topic="${OKTETO_NAMESPACE}-oktacoshop-gcp"
deleteTopic=$(gcloud pubsub topics delete "$topic")
if [ $exitCode -ne 0 ]; then
  echo "$deleteTopic" | grep -q "Resource doesn't exist in the project" 
  if [ $? -eq 0 ]; then
    echo "Failed to delete topic: $deleteTopic"
    exit 1
  fi
fi