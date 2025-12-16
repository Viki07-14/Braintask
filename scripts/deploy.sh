#!/bin/bash
set -e

AWS_REGION="ap-south-1"
AWS_ACCOUNT_ID="213375652280"
ECR_REPO="brain-task-app"
IMAGE_TAG="latest"

DEPLOYMENT_NAME="brain-task-deployment"
CONTAINER_NAME="brain-task"
SERVICE_NAME="brain-task-service"
NAMESPACE="default"

echo "Applying Kubernetes manifests..."
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

echo "Updating image..."
kubectl set image deployment/$DEPLOYMENT_NAME \
  $CONTAINER_NAME=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG \
  -n $NAMESPACE \
  --record

echo "Waiting for rollout..."
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE

echo "Current Pods:"
kubectl get pods -n $NAMESPACE

echo "Service details:"
kubectl get svc $SERVICE_NAME -n $NAMESPACE

echo "Waiting for LoadBalancer hostname..."
LB_HOSTNAME=""

# Wait until LoadBalancer hostname is assigned
while [ -z "$LB_HOSTNAME" ]; do
  LB_HOSTNAME=$(kubectl get svc $SERVICE_NAME \
    -n $NAMESPACE \
    -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
  sleep 5
done

echo "LoadBalancer Hostname: $LB_HOSTNAME"
