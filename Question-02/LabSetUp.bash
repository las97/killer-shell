#!/bin/bash
set -e

echo "=== Question 2: Helm & ClusterIssuer Setup ==="

# Check if helm is installed
if ! command -v helm &> /dev/null; then
    echo "⚠ Helm is not installed. Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Create namespace for cert-manager
kubectl create namespace cert-manager --dry-run=client -o yaml | kubectl apply -f -

# Create course directory
mkdir -p /course/2

echo "✓ Environment prepared for Helm chart deployment"
echo "✓ cert-manager namespace ready"
echo ""
echo "Validation criteria:"
echo "  1. Namespace 'cert-manager' exists"
echo "  2. Helm chart can be installed"
echo "  3. ClusterIssuer YAML is properly configured"
