#!/bin/bash
# Question 5 - Solution Notes

echo "Solution for Question 5:"
echo ""
echo "Required validations:"
echo "  ☐ Kustomize changes deployed"
echo "  ☐ The base kustomize output is missing the HorizontalPodAutoscaler entirely — it only renders ServiceAccount and Deployment. The HPA was never added to the base configuration. The ConfigMap has been successfully removed from all kustomize outputs (none contain "ConfigMap"), but the live ConfigMaps still exist in both namespaces and the HPAs were never created in the cluster."
echo ""
echo "Add kubectl commands and YAML manifests below:"
