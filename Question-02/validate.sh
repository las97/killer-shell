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
echo " Validating Question 2: Helm & ClusterIssuer"
echo "============================================="

check "Namespace cert-manager exists" kubectl get namespace cert-manager
check "Helm release cert-manager deployed" bash -c "helm list -n cert-manager 2>/dev/null | grep -qi deployed || helm list -A 2>/dev/null | grep -qi cert-manager"
check "ClusterIssuer YAML exists at /course/2/clusterissuer.yaml" test -f /course/2/clusterissuer.yaml
check "ClusterIssuer YAML has email field" grep -q "email" /course/2/clusterissuer.yaml

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
