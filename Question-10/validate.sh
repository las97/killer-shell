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
echo " Validating Question 10: RBAC"
echo "============================================="

SA_NS=$(kubectl get serviceaccount -A --no-headers 2>/dev/null | grep -v kube- | grep -v default | awk '{print $1}' | head -1)
SA_NAME=$(kubectl get serviceaccount -A --no-headers 2>/dev/null | grep -v kube- | grep -v default | awk '{print $2}' | head -1)

check "ServiceAccount exists in non-kube namespace" bash -c "
  kubectl get serviceaccount -A --no-headers 2>/dev/null | grep -v kube- | grep -v ' default ' | grep -q .
"

check "Role exists in same namespace as SA" bash -c "
  SA_NS=\$(kubectl get serviceaccount -A --no-headers 2>/dev/null | grep -v kube- | grep -v ' default ' | awk '{print \$1}' | head -1)
  [[ -n "\$SA_NS" ]] && kubectl get role -n "\$SA_NS" --no-headers 2>/dev/null | grep -q .
"

check "RoleBinding exists linking SA to Role" bash -c "
  SA_NS=\$(kubectl get serviceaccount -A --no-headers 2>/dev/null | grep -v kube- | grep -v ' default ' | awk '{print \$1}' | head -1)
  [[ -n "\$SA_NS" ]] && kubectl get rolebinding -n "\$SA_NS" --no-headers 2>/dev/null | grep -q .
"

check "SA can create secrets" bash -c "
  SA_NS=\$(kubectl get serviceaccount -A --no-headers 2>/dev/null | grep -v kube- | grep -v ' default ' | awk '{print \$1}' | head -1)
  SA_NAME=\$(kubectl get serviceaccount -A --no-headers 2>/dev/null | grep -v kube- | grep -v ' default ' | awk '{print \$2}' | head -1)
  [[ -n "\$SA_NAME" ]] && kubectl auth can-i create secrets -n "\$SA_NS" --as="system:serviceaccount:\${SA_NS}:\${SA_NAME}" 2>/dev/null | grep -q yes
"

check "SA can create configmaps" bash -c "
  SA_NS=\$(kubectl get serviceaccount -A --no-headers 2>/dev/null | grep -v kube- | grep -v ' default ' | awk '{print \$1}' | head -1)
  SA_NAME=\$(kubectl get serviceaccount -A --no-headers 2>/dev/null | grep -v kube- | grep -v ' default ' | awk '{print \$2}' | head -1)
  [[ -n "\$SA_NAME" ]] && kubectl auth can-i create configmaps -n "\$SA_NS" --as="system:serviceaccount:\${SA_NS}:\${SA_NAME}" 2>/dev/null | grep -q yes
"

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
