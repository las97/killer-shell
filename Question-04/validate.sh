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
echo " Validating Question 4: Pod Names/Termination"
echo "============================================="

check "File /course/4/pods-terminated-first.txt exists" test -f /course/4/pods-terminated-first.txt
check "File contains pod name c13-2x3-api" grep -q "c13-2x3-api" /course/4/pods-terminated-first.txt
check "File contains pod name c13-2x3-web" grep -q "c13-2x3-web" /course/4/pods-terminated-first.txt
check "File contains pod name c13-2x3-db" grep -q "c13-2x3-db" /course/4/pods-terminated-first.txt

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
