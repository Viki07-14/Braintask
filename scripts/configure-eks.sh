#!/bin/bash
set -e

AWS_REGION="ap-south-1"
EKS_CLUSTER_NAME="brain-task-cluster"

echo "Updating kubeconfig for EKS..."
aws eks update-kubeconfig \
  --region $AWS_REGION \
  --name $EKS_CLUSTER_NAME

kubectl get nodes
