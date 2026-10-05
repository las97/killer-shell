#!/bin/bash
set -e

echo "=== Question 8: Node Version Verification ==="

mkdir -p /course/8

# Create baseline node info
kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo}' > /course/8/node-info.json

echo "✓ Node information captured"
echo ""
echo "Validation criteria:"
echo "  1. Node exists in cluster"
echo "  2. Node status is Ready"
echo "  3. Kubelet version matches control plane"
echo "  4. Kube-proxy version matches control plane"
