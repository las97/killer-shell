#!/bin/bash
set -uo pipefail

PASS=0
FAIL=0
TOTAL=0

check() {
  local description="$1"
  shift
  TOTAL=$((TOTAL + 1))
  if "$@" >/dev/null 2>&1; then
    echo "  PASS: $description"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $description"
    FAIL=$((FAIL + 1))
  fi
}

echo "============================================="
echo " Validating Question 6: PersistentVolume/PVC"
echo "============================================="

check "PersistentVolume exists" bash -c "kubectl get pv --no-headers 2>/dev/null | grep -q ."

check "PV has storage capacity or storageClassName set" bash -c "
  kubectl get pv -o jsonpath='{.items[0].spec.capacity.storage}' 2>/dev/null | grep -q .
"

check "PersistentVolumeClaim exists (non-kube namespace)" bash -c "
  kubectl get pvc -A --no-headers 2>/dev/null | grep -v kube- | grep -q .
"

check "PVC is in Bound phase" bash -c "
  kubectl get pvc -A --no-headers 2>/dev/null | grep -v kube- | grep -q Bound
"

check "Deployment exists in same namespace as PVC" bash -c "
  PVC_NS=\$(kubectl get pvc -A --no-headers 2>/dev/null | grep -v kube- | grep Bound | awk '{print \$1}' | head -1)
  [[ -n "\$PVC_NS" ]] && kubectl get deployment -n "\$PVC_NS" --no-headers 2>/dev/null | grep -q .
"

check "Deployment references PVC via volumeMounts" bash -c "
  PVC_NS=\$(kubectl get pvc -A --no-headers 2>/dev/null | grep -v kube- | grep Bound | awk '{print \$1}' | head -1)
  PVC_NAME=\$(kubectl get pvc -A --no-headers 2>/dev/null | grep -v kube- | grep Bound | awk '{print \$2}' | head -1)
  [[ -n "\$PVC_NS" ]] && kubectl get deployment -n "\$PVC_NS" -o yaml 2>/dev/null | grep -q "\$PVC_NAME"
"

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
