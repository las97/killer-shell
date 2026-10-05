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
echo " Validating Question 14: Certificate Expiration"
echo "============================================="

check "File /course/14/expiration exists" test -f /course/14/expiration
check "File /course/14/expiration is non-empty" test -s /course/14/expiration
check "File /course/14/kubeadm-renew-certs.sh exists" test -f /course/14/kubeadm-renew-certs.sh
check "File /course/14/kubeadm-renew-certs.sh is executable" test -x /course/14/kubeadm-renew-certs.sh
check "File /course/14/kubeadm-renew-certs.sh is valid bash" bash -n /course/14/kubeadm-renew-certs.sh

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
