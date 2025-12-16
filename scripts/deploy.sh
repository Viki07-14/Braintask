#!/bin/bash
set -e

AWS_REGION="ap-south-1"
AWS_ACCOUNT_ID="213375652280"
ECR_REPO="brain-task-app"
IMAGE_TAG="latest"

echo "Applying Kubernetes manifests..."
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

echo "Updating image..."
kubectl set image deployment/brain-task-deployment \
  brain-task=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG \
  --record

echo "Waiting for rollout..."
kubectl rollout status deployment/brain-task-deployment

echo "Current Pods:"
kubectl get pods

echo "Service details:"
kubectl get svc
