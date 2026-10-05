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
echo " Validating Question 7: Node/Pod Scripts"
echo "============================================="

check "File /course/7/node.sh exists" test -f /course/7/node.sh
check "File /course/7/node.sh is executable" test -x /course/7/node.sh
check "File /course/7/node.sh is valid bash" bash -n /course/7/node.sh
check "File /course/7/pod.sh exists" test -f /course/7/pod.sh
check "File /course/7/pod.sh is executable" test -x /course/7/pod.sh
check "File /course/7/pod.sh is valid bash" bash -n /course/7/pod.sh

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
