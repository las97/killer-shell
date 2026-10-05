#!/bin/bash
set -e

echo "=== Question 3: StatefulSet Configuration ==="

# Create namespace
kubectl create namespace course-3 --dry-run=client -o yaml | kubectl apply -f -

# Create directory
mkdir -p /course/3

# Create a ConfigMap that the StatefulSet might use
kubectl apply -n course-3 -f - << 'YAML'
apiVersion: v1
kind: ConfigMap
metadata:
  name: statefulset-config
data:
  config.txt: "StatefulSet initialization config"
YAML

echo "✓ Namespace 'course-3' created"
echo "✓ ConfigMap initialized"
echo ""
echo "Validation criteria:"
echo "  1. StatefulSet is deployed with 1 replica"
echo "  2. StatefulSet pods are in Running state"
echo "  3. Persistent volumes are mounted"
