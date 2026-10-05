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
echo " Validating Question 9: Pod & API Secrets"
echo "============================================="

check "Pod exists in non-kube namespace" bash -c "
  kubectl get pods -A --no-headers 2>/dev/null | grep -v kube- | grep -q .
"

check "Pod is in Running state" bash -c "
  kubectl get pods -A --no-headers 2>/dev/null | grep -v kube- | grep -q Running
"

check "File /course/9/api-response.txt exists" test -f /course/9/api-response.txt
check "api-response.txt contains secrets or Secret" grep -qiE "(secrets|Secret)" /course/9/api-response.txt

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
