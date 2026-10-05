#!/bin/bash
set -e

echo "=== Question 7: Troubleshooting Scripts ==="

mkdir -p /course/7

# Create sample node.sh script template
cat > /course/7/node.sh << 'SCRIPT'
#!/bin/bash
# Node troubleshooting script
kubectl get nodes -o wide
kubectl describe nodes
SCRIPT

# Create sample pod.sh script template
cat > /course/7/pod.sh << 'SCRIPT'
#!/bin/bash
# Pod troubleshooting script
kubectl get pods -A
kubectl get events -A
SCRIPT

chmod +x /course/7/node.sh /course/7/pod.sh

echo "✓ Troubleshooting script templates created"
echo ""
echo "Validation criteria:"
echo "  1. File /course/7/node.sh is executable and valid bash"
echo "  2. File /course/7/pod.sh is executable and valid bash"
