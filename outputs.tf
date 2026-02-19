output "oidc_role_this" {
  description = "The ARN of the OIDC role"
  value       = try(aws_iam_role.this.arn, "")
}

output "iodc_role_this" {
  description = "DEPRECATED: use oidc_role_this"
  value       = try(aws_iam_role.this.arn, "")
}

output "aws_iam_openid_connect_provider_arn" {
  description = "Arn of openid connect provider"
  value       = local.aws_iam_openid_connect_provider_arn
}
