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
echo " Validating Question 11: DaemonSet"
echo "============================================="

check "DaemonSet exists (non-kube namespace)" bash -c "
  kubectl get daemonset -A --no-headers 2>/dev/null | grep -v kube- | grep -q .
"

check "DaemonSet has exactly 1 container in pod spec" bash -c "
  DS_NS=\$(kubectl get daemonset -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$1}' | head -1)
  DS_NAME=\$(kubectl get daemonset -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$2}' | head -1)
  [[ -n "\$DS_NAME" ]] && COUNT=\$(kubectl get daemonset -n "\$DS_NS" "\$DS_NAME" -o jsonpath='{.spec.template.spec.containers}' 2>/dev/null | python3 -c 'import sys,json; d=json.load(sys.stdin); print(len(d))' 2>/dev/null)
  [[ "\$COUNT" == "1" ]]
"

check "DaemonSet container image is set" bash -c "
  DS_NS=\$(kubectl get daemonset -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$1}' | head -1)
  DS_NAME=\$(kubectl get daemonset -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$2}' | head -1)
  [[ -n "\$DS_NAME" ]] && kubectl get daemonset -n "\$DS_NS" "\$DS_NAME" -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null | grep -q .
"

check "DaemonSet desiredNumberScheduled >= 1" bash -c "
  DS_NS=\$(kubectl get daemonset -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$1}' | head -1)
  DS_NAME=\$(kubectl get daemonset -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$2}' | head -1)
  DESIRED=\$(kubectl get daemonset -n "\$DS_NS" "\$DS_NAME" -o jsonpath='{.status.desiredNumberScheduled}' 2>/dev/null)
  [[ "\$DESIRED" -ge 1 ]]
"

check "DaemonSet numberReady equals desiredNumberScheduled" bash -c "
  DS_NS=\$(kubectl get daemonset -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$1}' | head -1)
  DS_NAME=\$(kubectl get daemonset -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$2}' | head -1)
  DESIRED=\$(kubectl get daemonset -n "\$DS_NS" "\$DS_NAME" -o jsonpath='{.status.desiredNumberScheduled}' 2>/dev/null)
  READY=\$(kubectl get daemonset -n "\$DS_NS" "\$DS_NAME" -o jsonpath='{.status.numberReady}' 2>/dev/null)
  [[ -n "\$DESIRED" && "\$DESIRED" == "\$READY" ]]
"

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
