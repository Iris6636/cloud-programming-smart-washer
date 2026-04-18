# Reference: Generated Terraform State Snapshot

This directory contains Terraform files exported from the original AWS deployment using `terraformer import`. These files serve as a **reference only** and should NOT be used directly for deployment.

## Why can't these be used directly?

1. **Hardcoded AWS Account ID**: All ARNs contain `701030859948` (the original classroom AWS account)
2. **Mixed resources from other teams**: The API Gateway exports include Team02, Team04, Team11, Team18 resources
3. **No resource references**: All resource connections use hardcoded strings instead of Terraform references
4. **Stale state files**: The `.tfstate` files reference resources that may no longer exist

## How these were used

The files in `generated/` were analyzed to understand the original AWS architecture, then rewritten as proper Terraform IaC in `deployment/infra/`. The new Terraform files use:
- Variables instead of hardcoded values
- Resource references (e.g., `aws_lambda_function.start_wash.arn`) instead of hardcoded ARNs
- Only team06 resources (other teams' resources removed)
