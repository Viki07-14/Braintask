#!/bin/bash

echo "Updating kubeconfig for EKS..."
aws eks update-kubeconfig --region ap-south-1 --name brain-task-cluster

kubectl get nodes

