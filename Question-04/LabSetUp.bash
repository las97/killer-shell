#!/bin/bash
set -e

echo "=== Question 4: Pod Names & Termination ==="

mkdir -p /course/4

# Create namespace
kubectl create namespace course-4 --dry-run=client -o yaml | kubectl apply -f -

# Create sample pods with specific names
kubectl apply -n course-4 -f - << 'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: c13-2x3-api
spec:
  containers:
  - name: api
    image: nginx:latest
    imagePullPolicy: IfNotPresent
---
apiVersion: v1
kind: Pod
metadata:
  name: c13-2x3-web
spec:
  containers:
  - name: web
    image: nginx:latest
    imagePullPolicy: IfNotPresent
---
apiVersion: v1
kind: Pod
metadata:
  name: c13-2x3-db
spec:
  containers:
  - name: db
    image: nginx:latest
    imagePullPolicy: IfNotPresent
YAML

echo "✓ Namespace 'course-4' created"
echo "✓ Sample pods created"
echo ""
echo "Validation criteria:"
echo "  1. Pods are created with correct names"
echo "  2. Terminated pods are tracked"
echo "  3. Pod termination order is correct"
