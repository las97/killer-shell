#!/bin/bash
set -e

echo "=== Question 17: Pod Configuration ==="

mkdir -p /course/17

# Create namespace
kubectl create namespace course-17 --dry-run=client -o yaml | kubectl apply -f -

# Create baseline pod
kubectl apply -n course-17 -f - << 'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: configured-pod
  labels:
    env: lab
    tier: frontend
spec:
  containers:
  - name: app
    image: nginx:latest
    imagePullPolicy: IfNotPresent
YAML

echo "✓ Pod created in namespace 'course-17'"
echo ""
echo "Validation criteria:"
echo "  1. Pod 'configured-pod' is running"
echo "  2. Pod has single container named 'app'"
echo "  3. Container image is correct"
echo "  4. Pod has correct labels"
echo "  5. Container info is saved in /course/17/pod-container.txt"
