# OIDC variables
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "url" {
  description = "The URL of the identity provider. Corresponds to the iss claim."
  type        = string
  default     = ""
}

variable "repo_ref" {
  description = "Conditional StringLike reference"
  type        = list(string)
  default     = []
}

variable "client_id_list" {
  description = "A list of client IDs (also known as audiences)"
  type        = list(string)
  default     = []
}

variable "thumbprint_list" {
  description = "A list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s)."
  type        = list(string)
  default     = []
}

# Optional policies to be attached into OIDC IAM role
# Extra statement in policy to assume AWS service
variable "service_name_to_assume" {
  description = "A name of the AWS service what we want to assume, additionally"
  type        = list(string)
  default     = []
}

variable "service_policy_assume" {
  description = "Service policy to be used by OIDC IAM  role (assume some specific service)"
  type        = bool
  default     = false
}

# S3 bucket access
variable "s3_policy" {
  description = "S3 policy to be used by OIDC IAM  role"
  type        = bool
  default     = false
}

variable "s3_bucket_arn" {
  description = "S3 bucket arn to be used in access policy"
  type        = string
  default     = ""
}

variable "s3_bucket_path" {
  description = "S3 bucket path to be used in access policy value should stat from slash"
  type        = string
  default     = ""
}

variable "s3_bucket_actions" {
  description = "A list of permissions what should be used in bucket policy, default to read only"
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:GetBucketAcl",
    "s3:GetBucketLocation",
    "s3:PutObject",
    "s3:PutObjectAcl",
    "s3:ListBucket"
  ]
}

# ECR access
variable "ecr_access" {
  description = "ECR access by OIDC IAM  role"
  type        = bool
  default     = false
}

variable "ecr_repo_arn" {
  description = "ECR repo ARN"
  type        = list(string)
  default     = []
}

variable "ecr_actions" {
  description = "A list of permissions what should be used in ECR access policy, default to read only"
  type        = list(string)
  default = [
    "ecr:GetAuthorizationToken",
    "ecr:BatchCheckLayerAvailability",
    "ecr:GetDownloadUrlForLayer",
    "ecr:GetRepositoryPolicy",
    "ecr:DescribeRepositories",
    "ecr:ListImages",
    "ecr:DescribeImages",
    "ecr:BatchGetImage",
    "ecr:DescribeImageScanFindings",
  ]
}

# Custom IAM policy attachment.
variable "custom_policy_arns" {
  description = "List of IAM policy ARNs what will be attached to OIDC IAM role"
  type        = list(string)
  default     = []
}

variable "aws_iam_openid_connect_provider_arn" {
  description = "When provided, will not create aws_iam_openid_connect_provider, but use provided in policy"
  type        = string
  default     = ""
}

variable "use_existing_aws_iam_openid_connect_provider" {
  description = "If true will use aws_iam_openid_connect_provider_arn as arn"
  type        = bool
  default     = false
}
