#!/bin/bash
set -e

echo "=== Question 14: Certificate Expiration ==="

mkdir -p /course/14

# Get certificate expiration info
echo "Current cluster certificate expiration:" 
kubeadm certs check-expiration 2>/dev/null || echo "Note: kubeadm not available in all environments"

echo "✓ Directory /course/14 created for certificate files"
echo ""
echo "Validation criteria:"
echo "  1. File /course/14/expiration exists with cert expiration data"
echo "  2. File /course/14/kubeadm-renew-certs.sh is executable"
echo "  3. Script correctly renews certificates"
