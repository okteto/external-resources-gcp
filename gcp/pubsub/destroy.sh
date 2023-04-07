#!/bin/sh

topic="${OKTETO_NAMESPACE}-oktacoshop-gcp"
subscription="${topic}-sub"

deleteSubscription=$(gcloud pubsub subscriptions delete "$subscription" 2>/dev/null)
exitCode=$?

if [ $exitCode -ne 0 ]; then
  echo "$deleteSubscription" | grep -q "Resource not found" 
  if [ $? -eq 0 ]; then
    echo "Failed to delete subscription: $deleteSubscription"
    exit 1
  fi
fi


deleteTopic=$(gcloud pubsub topics delete "$topic" 2>/dev/null)
if [ $exitCode -ne 0 ]; then
  echo "$deleteTopic" | grep -q "Resource not found" 
  if [ $? -eq 0 ]; then
    echo "Failed to delete topic: $deleteTopic"
    exit 1
  fi
fi

echo "PUB/SUB resources destroyed"
exit 0