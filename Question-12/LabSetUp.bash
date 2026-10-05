#!/bin/bash
set -e

echo "=== Question 12: Multi-container Deployment ==="

mkdir -p /course/12

# Create namespace
kubectl create namespace course-12 --dry-run=client -o yaml | kubectl apply -f -

# Create baseline multi-container deployment
kubectl apply -n course-12 -f - << 'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web
        image: nginx:latest
        imagePullPolicy: IfNotPresent
      - name: sidecar
        image: nginx:latest
        imagePullPolicy: IfNotPresent
YAML

echo "✓ Multi-container Deployment created in namespace 'course-12'"
echo ""
echo "Validation criteria:"
echo "  1. Deployment 'web-app' exists"
echo "  2. Deployment has 3 replicas"
echo "  3. At least 2 replicas are running"
echo "  4. Each pod has 2 containers"
echo "  5. Containers are named correctly"
