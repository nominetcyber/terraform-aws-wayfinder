output "cluster_endpoint" {
  description = "The endpoint for the Wayfinder EKS Kubernetes API"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data for the Wayfinder EKS cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  description = "The name of the Wayfinder EKS cluster"
  value       = module.eks.cluster_name
}

output "wayfinder_api_url" {
  description = "The URL for the Wayfinder API"
  value       = "https://${var.wayfinder_domain_name_api}"
}

output "wayfinder_ui_url" {
  description = "The URL for the Wayfinder UI"
  value       = "https://${var.wayfinder_domain_name_ui}"
}

output "wayfinder_instance_identifier" {
  description = "The unique identifier for the Wayfinder instance"
  value       = local.wayfinder_instance_id
}

output "wayfinder_iam_role_arn" {
  description = "The ARN of the IAM role used by Wayfinder"
  value       = module.wayfinder_irsa_role.iam_role_arn
}