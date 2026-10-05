#!/bin/bash
set -e

echo "=== Question 5: Kustomize Setup ==="

mkdir -p /course/5/kustomize/{base,prod}
cd /course/5/kustomize

# Create base kustomization
cat > base/kustomization.yaml << 'YAML'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - configmap.yaml
  - deployment.yaml

namespace: course-5
YAML

cat > base/configmap.yaml << 'YAML'
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  environment: base
YAML

cat > base/deployment.yaml << 'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
      - name: app
        image: nginx:latest
YAML

# Create prod overlay
cat > prod/kustomization.yaml << 'YAML'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

bases:
  - ../base

configMapGenerator:
  - name: app-config
    behavior: merge
    literals:
      - environment=prod
YAML

echo "✓ Kustomize directory structure created"
echo "✓ Base and production overlays configured"
echo ""
echo "Validation criteria:"
echo "  1. ConfigMap removed from base when required"
echo "  2. HPA added to base with correct replica count"
echo "  3. HPA replicas overridden in prod overlay"
