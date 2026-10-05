#!/bin/bash
set -e

echo "=== Question 16: CoreDNS Custom Domain Configuration ==="

mkdir -p /course/16

# Backup CoreDNS configmap
kubectl get configmap coredns -n kube-system -o yaml > /course/16/coredns-backup.yaml

echo "✓ CoreDNS configuration backed up"
echo ""
echo "Validation criteria:"
echo "  1. CoreDNS configuration backup exists"
echo "  2. DNS resolution works for kubernetes.default.svc.custom-domain"
echo "  3. Custom domain suffix is properly configured"
