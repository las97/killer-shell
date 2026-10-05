#!/bin/bash
set -e

echo "=== Question 9: Pod API Response ==="

mkdir -p /course/9

# Create namespace
kubectl create namespace course-9 --dry-run=client -o yaml | kubectl apply -f -

# Create a simple pod
kubectl apply -n course-9 -f - << 'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: api-tester
spec:
  containers:
  - name: api-client
    image: curlimages/curl:latest
    command: ["/bin/sh", "-c", "sleep 3600"]
YAML

echo "✓ Namespace 'course-9' created"
echo "✓ API tester pod deployed"
echo ""
echo "Validation criteria:"
echo "  1. Pod is running"
echo "  2. Pod can access Kubernetes API"
echo "  3. API response contains secrets (if applicable)"
