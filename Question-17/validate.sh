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
echo " Validating Question 17: Pod Configuration"
echo "============================================="

check "Pod exists in non-kube namespace" bash -c "
  kubectl get pods -A --no-headers 2>/dev/null | grep -v kube- | grep -q .
"

check "Pod is in Running state" bash -c "
  kubectl get pods -A --no-headers 2>/dev/null | grep -v kube- | grep -q Running
"

check "Pod has exactly 1 container" bash -c "
  POD_NS=\$(kubectl get pods -A --no-headers 2>/dev/null | grep -v kube- | grep Running | awk '{print \$1}' | head -1)
  POD_NAME=\$(kubectl get pods -A --no-headers 2>/dev/null | grep -v kube- | grep Running | awk '{print \$2}' | head -1)
  [[ -n "\$POD_NAME" ]] && COUNT=\$(kubectl get pod -n "\$POD_NS" "\$POD_NAME" -o jsonpath='{.spec.containers}' 2>/dev/null | python3 -c 'import sys,json; d=json.load(sys.stdin); print(len(d))' 2>/dev/null)
  [[ "\$COUNT" == "1" ]]
"

check "Pod has labels set" bash -c "
  POD_NS=\$(kubectl get pods -A --no-headers 2>/dev/null | grep -v kube- | grep Running | awk '{print \$1}' | head -1)
  POD_NAME=\$(kubectl get pods -A --no-headers 2>/dev/null | grep -v kube- | grep Running | awk '{print \$2}' | head -1)
  [[ -n "\$POD_NAME" ]] && kubectl get pod -n "\$POD_NS" "\$POD_NAME" -o jsonpath='{.metadata.labels}' 2>/dev/null | grep -q .
"

check "File /course/17/pod-container.txt exists" test -f /course/17/pod-container.txt
check "File /course/17/pod-container.txt is non-empty and has container info" test -s /course/17/pod-container.txt

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
