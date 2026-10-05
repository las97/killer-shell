#!/bin/bash
set -e

echo "=== Question 6: Storage Setup ==="

mkdir -p /course/6

# Create namespace
kubectl create namespace course-6 --dry-run=client -o yaml | kubectl apply -f -

# Create local storage directory (for minikube or docker-for-desktop)
mkdir -p /tmp/pv-storage

echo "✓ Namespace 'course-6' created"
echo "✓ Storage directory initialized"
echo ""
echo "Validation criteria:"
echo "  1. PersistentVolume exists and is Available"
echo "  2. PersistentVolume correctly defined with storage capacity"
echo "  3. PersistentVolumeClaim exists and is Bound"
echo "  4. Deployment mounts the volume correctly"
