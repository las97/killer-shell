#!/bin/bash
set -e

echo "=== Question 13: HTTPRoute Gateway API Configuration ==="

mkdir -p /course/13

# Create namespace
kubectl create namespace course-13 --dry-run=client -o yaml | kubectl apply -f -

# Create services for routing
kubectl apply -n course-13 -f - << 'YAML'
apiVersion: v1
kind: Service
metadata:
  name: web-desktop
spec:
  selector:
    app: desktop
  ports:
  - port: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web-mobile
spec:
  selector:
    app: mobile
  ports:
  - port: 80
YAML

echo "✓ Services created in namespace 'course-13'"
echo ""
echo "Validation criteria:"
echo "  1. HTTPRoute exists"
echo "  2. Path /desktop routes to web-desktop"
echo "  3. Path /mobile routes to web-mobile"
echo "  4. User-Agent routing works correctly"
