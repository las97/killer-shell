#!/bin/bash
set -e

echo "=== Question 11: DaemonSet Configuration ==="

mkdir -p /course/11

# Create namespace
kubectl create namespace course-11 --dry-run=client -o yaml | kubectl apply -f -

# Create baseline DaemonSet
kubectl apply -n course-11 -f - << 'YAML'
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-monitor
spec:
  selector:
    matchLabels:
      name: node-monitor
  template:
    metadata:
      labels:
        name: node-monitor
    spec:
      containers:
      - name: monitor
        image: nginx:latest
        imagePullPolicy: IfNotPresent
YAML

echo "✓ DaemonSet template created in namespace 'course-11'"
echo ""
echo "Validation criteria:"
echo "  1. DaemonSet 'node-monitor' exists"
echo "  2. DaemonSet has single container"
echo "  3. Container image is correct"
echo "  4. DaemonSet has running instances on each node"
