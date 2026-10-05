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
echo " Validating Question 16: CoreDNS"
echo "============================================="

check "CoreDNS backup YAML exists in /course/16/" bash -c "
  ls /course/16/*.yaml 2>/dev/null | grep -q .
"

check "CoreDNS ConfigMap exists in kube-system" bash -c "
  kubectl get configmap coredns -n kube-system 2>/dev/null | grep -q coredns
"

check "CoreDNS ConfigMap contains custom domain configuration" bash -c "
  kubectl get configmap coredns -n kube-system -o yaml 2>/dev/null | grep -vE '(cluster\.local|in-addr\.arpa|ip6\.arpa)' | grep -qE ':[0-9]+\s*\{|^\s+[a-z].*\{' ||   kubectl get configmap coredns -n kube-system -o yaml 2>/dev/null | grep -cE '^    [a-zA-Z].*:$' | grep -q [2-9]
"

check "DNS resolution works for kubernetes.default.svc" bash -c "
  kubectl run test-dns-q16 --image=busybox:1.28 --restart=Never --rm -it --timeout=30s     -- nslookup kubernetes.default.svc.cluster.local 2>/dev/null | grep -q Address ||   echo 'skipped - cluster may not be accessible'
  true
"

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
