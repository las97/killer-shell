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
echo " Validating Question 8: Node Versions"
echo "============================================="

check "At least one non-control-plane node exists" bash -c "
  kubectl get nodes --no-headers 2>/dev/null | grep -v control-plane | grep -v master | grep -q .
"

check "Worker node is in Ready state" bash -c "
  kubectl get nodes --no-headers 2>/dev/null | grep -v control-plane | grep -v master | grep -q ' Ready'
"

check "Worker kubelet version matches control plane" bash -c "
  CP_VER=\$(kubectl get nodes --no-headers 2>/dev/null | grep -E 'control-plane|master' | awk '{print \$5}' | head -1)
  WK_VER=\$(kubectl get nodes --no-headers 2>/dev/null | grep -vE 'control-plane|master' | awk '{print \$5}' | head -1)
  [[ -n "\$CP_VER" && "\$CP_VER" == "\$WK_VER" ]]
"

check "kube-proxy running on worker node" bash -c "
  kubectl get pods -n kube-system --no-headers 2>/dev/null | grep kube-proxy | grep -q Running
"

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
