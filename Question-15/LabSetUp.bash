#!/bin/bash
set -e

echo "=== Question 15: NetworkPolicy Configuration ==="

mkdir -p /course/15

# Create namespace
kubectl create namespace course-15 --dry-run=client -o yaml | kubectl apply -f -

# Create backend and database deployments
kubectl apply -n course-15 -f - << 'YAML'
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: backend
spec:
  serviceName: backend
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: nginx:latest
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: db1
spec:
  serviceName: db1
  replicas: 1
  selector:
    matchLabels:
      app: db1
  template:
    metadata:
      labels:
        app: db1
    spec:
      containers:
      - name: db1
        image: nginx:latest
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: db2
spec:
  serviceName: db2
  replicas: 1
  selector:
    matchLabels:
      app: db2
  template:
    metadata:
      labels:
        app: db2
    spec:
      containers:
      - name: db2
        image: nginx:latest
---
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  clusterIP: None
  selector:
    app: backend
---
apiVersion: v1
kind: Service
metadata:
  name: db1
spec:
  clusterIP: None
  selector:
    app: db1
---
apiVersion: v1
kind: Service
metadata:
  name: db2
spec:
  clusterIP: None
  selector:
    app: db2
YAML

echo "✓ StatefulSets and Services created in namespace 'course-15'"
echo ""
echo "Validation criteria:"
echo "  1. NetworkPolicy 'db-access' exists"
echo "  2. Backend can reach db1 on port 1111"
echo "  3. Backend can reach db2 on port 2222"
echo "  4. Vault connection is restricted"
