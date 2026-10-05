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
echo " Validating Question 12: Multi-Container Deployment"
echo "============================================="

check "Deployment exists (non-kube namespace)" bash -c "
  kubectl get deployment -A --no-headers 2>/dev/null | grep -v kube- | grep -q .
"

check "Deployment has replicas >= 3" bash -c "
  DEP_NS=\$(kubectl get deployment -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$1}' | head -1)
  DEP_NAME=\$(kubectl get deployment -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$2}' | head -1)
  REP=\$(kubectl get deployment -n "\$DEP_NS" "\$DEP_NAME" -o jsonpath='{.spec.replicas}' 2>/dev/null)
  [[ "\$REP" -ge 3 ]]
"

check "Deployment has readyReplicas >= 2" bash -c "
  DEP_NS=\$(kubectl get deployment -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$1}' | head -1)
  DEP_NAME=\$(kubectl get deployment -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$2}' | head -1)
  READY=\$(kubectl get deployment -n "\$DEP_NS" "\$DEP_NAME" -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
  [[ "\$READY" -ge 2 ]]
"

check "Pod spec has exactly 2 containers" bash -c "
  DEP_NS=\$(kubectl get deployment -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$1}' | head -1)
  DEP_NAME=\$(kubectl get deployment -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$2}' | head -1)
  COUNT=\$(kubectl get deployment -n "\$DEP_NS" "\$DEP_NAME" -o jsonpath='{.spec.template.spec.containers}' 2>/dev/null | python3 -c 'import sys,json; d=json.load(sys.stdin); print(len(d))' 2>/dev/null)
  [[ "\$COUNT" == "2" ]]
"

check "Both container names and images are set" bash -c "
  DEP_NS=\$(kubectl get deployment -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$1}' | head -1)
  DEP_NAME=\$(kubectl get deployment -A --no-headers 2>/dev/null | grep -v kube- | awk '{print \$2}' | head -1)
  kubectl get deployment -n "\$DEP_NS" "\$DEP_NAME" -o jsonpath='{.spec.template.spec.containers[*].image}' 2>/dev/null | grep -q . &&   kubectl get deployment -n "\$DEP_NS" "\$DEP_NAME" -o jsonpath='{.spec.template.spec.containers[*].name}' 2>/dev/null | grep -q .
"

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
