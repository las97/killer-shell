#!/bin/bash
set -e

echo "=== Question 10: RBAC (ServiceAccount, Role, RoleBinding) ==="

mkdir -p /course/10

# Create namespace
kubectl create namespace course-10 --dry-run=client -o yaml | kubectl apply -f -

# Create initial resources
kubectl apply -n course-10 -f - << 'YAML'
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-sa
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-role
rules:
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["create", "get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: app-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: app-role
subjects:
  - kind: ServiceAccount
    name: app-sa
YAML

echo "✓ RBAC resources created in namespace 'course-10'"
echo ""
echo "Validation criteria:"
echo "  1. ServiceAccount 'app-sa' exists"
echo "  2. Role 'app-role' exists with correct permissions"
echo "  3. RoleBinding links ServiceAccount to Role"
echo "  4. ServiceAccount can create secrets"
echo "  5. ServiceAccount can create configmaps"
