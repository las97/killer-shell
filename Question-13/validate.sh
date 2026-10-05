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
echo " Validating Question 13: HTTPRoute"
echo "============================================="

check "HTTPRoute resource exists" bash -c "
  kubectl get httproute -A --no-headers 2>/dev/null | grep -q .
"

check "HTTPRoute has path /desktop rule" bash -c "
  kubectl get httproute -A -o yaml 2>/dev/null | grep -q '/desktop'
"

check "HTTPRoute /desktop routes to web-desktop service" bash -c "
  kubectl get httproute -A -o yaml 2>/dev/null | grep -q 'web-desktop'
"

check "HTTPRoute has path /mobile rule" bash -c "
  kubectl get httproute -A -o yaml 2>/dev/null | grep -q '/mobile'
"

check "HTTPRoute /mobile routes to web-mobile service" bash -c "
  kubectl get httproute -A -o yaml 2>/dev/null | grep -q 'web-mobile'
"

check "HTTPRoute has header-based routing (User-Agent)" bash -c "
  kubectl get httproute -A -o yaml 2>/dev/null | grep -qi 'user-agent'
"

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
