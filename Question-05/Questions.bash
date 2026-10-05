#!/bin/bash
# Killer Shell Exam - Question 5
# Validation Criteria:
  - Kustomize changes deployed
  - The base kustomize output is missing the HorizontalPodAutoscaler entirely — it only renders ServiceAccount and Deployment. The HPA was never added to the base configuration. The ConfigMap has been successfully removed from all kustomize outputs (none contain "ConfigMap"), but the live ConfigMaps still exist in both namespaces and the HPAs were never created in the cluster.

echo "Question 5 Tasks:"
echo ""
echo "Validation checks:"
echo "  - Kustomize changes deployed"
echo "  - The base kustomize output is missing the HorizontalPodAutoscaler entirely — it only renders ServiceAccount and Deployment. The HPA was never added to the base configuration. The ConfigMap has been successfully removed from all kustomize outputs (none contain "ConfigMap"), but the live ConfigMaps still exist in both namespaces and the HPAs were never created in the cluster."
