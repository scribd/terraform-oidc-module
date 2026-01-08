output "iodc_role_this" {
  description = "The ARN of the OIDC role"
  value       = try(aws_iam_role.this.arn, "")
}
