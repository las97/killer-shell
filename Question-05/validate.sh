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
echo " Validating Question 5: Kustomize HPA"
echo "============================================="

check "Directory /course/5/kustomize/base exists" test -d /course/5/kustomize/base

check "HPA resource file exists in base" bash -c "
  grep -rl 'HorizontalPodAutoscaler' /course/5/kustomize/base/ 2>/dev/null | grep -q '\.yaml\$'
"

check "HPA has minReplicas or maxReplicas set" bash -c "
  grep -rl 'HorizontalPodAutoscaler' /course/5/kustomize/base/ 2>/dev/null | xargs grep -l 'Replicas' 2>/dev/null | grep -q .
"

check "Prod overlay directory exists" test -d /course/5/kustomize/prod

check "Prod overlay patches HPA replicas" bash -c "
  grep -r 'eplicas' /course/5/kustomize/prod/ 2>/dev/null | grep -q .
"

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
