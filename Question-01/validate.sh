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
echo " Validating Question 1: Contexts Configuration"
echo "============================================="

check "File /course/1/contexts exists" test -f /course/1/contexts
check "contexts contains admin-context" grep -q "admin-context" /course/1/contexts
check "contexts contains dev-context" grep -q "dev-context" /course/1/contexts
check "contexts contains test-context" grep -q "test-context" /course/1/contexts
check "File /course/1/current-context exists" test -f /course/1/current-context
check "current-context contains admin-context" grep -q "admin-context" /course/1/current-context
check "File /course/1/cert exists" test -f /course/1/cert
check "cert contains certificate data" grep -qE "(CERTIFICATE|BEGIN|LS0t)" /course/1/cert

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
