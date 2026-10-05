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
echo " Validating Question 3: StatefulSet"
echo "============================================="

# Find any StatefulSet outside kube-* namespaces
SS_NS=$(kubectl get statefulset -A --no-headers 2>/dev/null | grep -v "kube-" | awk '{print $1}' | head -1)
SS_NAME=$(kubectl get statefulset -A --no-headers 2>/dev/null | grep -v "kube-" | awk '{print $2}' | head -1)

check "StatefulSet exists (non-kube namespace)" bash -c "kubectl get statefulset -A --no-headers 2>/dev/null | grep -v kube- | grep -q ."

check "StatefulSet has exactly 1 replica" bash -c "
  SS_NAME=\$(kubectl get statefulset -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$2}' | head -1)
  SS_NS=\$(kubectl get statefulset -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$1}' | head -1)
  [[ -n "\$SS_NAME" ]] && kubectl get statefulset -n "\$SS_NS" "\$SS_NAME" -o jsonpath='{.spec.replicas}' 2>/dev/null | grep -q '^1$'
"

check "StatefulSet pod is Running" bash -c "
  SS_NS=\$(kubectl get statefulset -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$1}' | head -1)
  SS_NAME=\$(kubectl get statefulset -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$2}' | head -1)
  [[ -n "\$SS_NAME" ]] && kubectl get pods -n "\$SS_NS" --no-headers 2>/dev/null | grep "\$SS_NAME" | grep -q Running
"

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
