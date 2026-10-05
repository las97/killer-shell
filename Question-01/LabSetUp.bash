#!/bin/bash
set -e

echo "=== Question 1: Contexts Configuration ==="
echo "Setting up kubeconfig context files..."

# Create course directory
mkdir -p /course/1

# Generate sample kubeconfig files
cat > /course/1/contexts << 'KUBECONFIG'
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWR3Q2dZREVRSUZBREFOQmdrcWhraUc5dzBCQVFzRkFERFBNUXN3Q1FZRFZRUUdFd0pWVXpFaU1DQUcKQTFVRUNoTVpSMjl2WjJ4bElGUnlkWE4wSUZObGNuWmxjaTFsZUdGdGNHeGxNUmt3RndZRFZRUURFeEIzZDNjdQpaMmR2YjI5c0xtTnZiVEFIQmdOVkJBMFRBMnh2WW1jd0hoY05NakF3TlRFMk1qTTJNRFEzV2hjTk1qRXdOVEUzCk1qTTJNRFEzV2pCUE1Rc3dDUVlEVlFRR0V3SlZVekVpTUNBR0ExVUVDaE1aUjI5dloyeGxJRlJ5ZFhOMElGTmwKY25abGNpMWxlR0Z0Y0d4bE1Sa3dGd1lEVlFRREV4QjNkM2N1WjJkdmIyOXNMbU52YlRDQm56QU5CZ2txaGtpRwo5dzBCQVFRRkFEQm1BREJqQmdOVkJBMFRBMnh2WW1jd0hoY05NakF3TlRFMk1qTTJNRFEzV2hjTk1qRXdOVEUzCk1qTTJNRFEzV2pCUE1Rc3dDUVlEVlFRR0V3SlZVekVpTUNBR0ExVUVDaE1aUjI5dloyeGxJRlJ5ZFhOMklGTmwKY25abGNpMWxlR0Z0Y0d4bE1Sa3dGd1lEVlFRREV4QjNkM2N1WjJkdmIyOXNMbU52YlRCbU1CQUdCeXFHU000OQpBd0VIQmdzcWhraUc5dzBCQVFFc1kzQWlCZ2dxaGtqT1BRUURCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkpCCkNBSUdDY2pHU001MEFRMEZBQWhWZ0VGRVJCRVJCQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUEKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    server: https://kubernetes.default:443
  name: kubernetes-context
contexts:
- context:
    cluster: kubernetes-context
    user: admin-user
  name: admin-context
- context:
    cluster: kubernetes-context
    user: dev-user
  name: dev-context
- context:
    cluster: kubernetes-context
    user: test-user
  name: test-context
current-context: admin-context
kind: Config
preferences: {}
users:
- name: admin-user
  user:
    token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
- name: dev-user
  user:
    token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
- name: test-user
  user:
    token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
KUBECONFIG

# Create current-context file
echo "admin-context" > /course/1/current-context

# Create certificate file
cat > /course/1/cert << 'CERT'
-----BEGIN CERTIFICATE-----
MIICyDCCAbACgYDEQIFADANBgkqhkiG9w0BAQsFADDPMQswCQYDVQQGEwJVUzEi
MCAGA1UEChMZR4VEmPwJVUzEiMCAGA1UEChMZG3d2ZjJsIFJUdXN0TmxjbmZs
-----END CERTIFICATE-----
CERT

echo "✓ Kubeconfig files created in /course/1/"
echo ""
echo "Validation criteria:"
echo "  1. File /course/1/contexts contains three context definitions"
echo "  2. File /course/1/current-context contains active context name"
echo "  3. File /course/1/cert contains certificate data"
