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
echo " Validating Question 15: NetworkPolicy"
echo "============================================="

check "NetworkPolicy exists" bash -c "
  kubectl get networkpolicy -A --no-headers 2>/dev/null | grep -q .
"

check "StatefulSet named backend exists and pods are ready" bash -c "
  NS=\$(kubectl get statefulset -A --no-headers 2>/dev/null | grep ' backend' | awk '{print \$1}' | head -1)
  [[ -n "\$NS" ]] && kubectl get statefulset backend -n "\$NS" -o jsonpath='{.status.readyReplicas}' 2>/dev/null | grep -qE '^[1-9]'
"

check "StatefulSet named db1 exists" bash -c "
  kubectl get statefulset -A --no-headers 2>/dev/null | grep -q ' db1 '
"

check "StatefulSet named db2 exists" bash -c "
  kubectl get statefulset -A --no-headers 2>/dev/null | grep -q ' db2 '
"

check "StatefulSet named vault or vault pods exist" bash -c "
  kubectl get statefulset -A --no-headers 2>/dev/null | grep -q ' vault' ||   kubectl get pods -A --no-headers 2>/dev/null | grep -q vault
"

check "NetworkPolicy allows backend to db1 traffic (policy spec references db1)" bash -c "
  kubectl get networkpolicy -A -o yaml 2>/dev/null | grep -q 'db1'
"

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
