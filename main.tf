locals {
  s3_policy                           = var.s3_policy
  service_policy_assume               = var.service_policy_assume
  ecr_access                          = var.ecr_access
  custom_policy_arns                  = var.custom_policy_arns
  aws_iam_openid_connect_provider_arn = var.use_existing_aws_iam_openid_connect_provider ? var.aws_iam_openid_connect_provider_arn : join("", aws_iam_openid_connect_provider.this.*.arn)
}

resource "aws_iam_openid_connect_provider" "this" {
  count           = var.use_existing_aws_iam_openid_connect_provider ? 0 : 1
  url             = var.url
  client_id_list  = var.client_id_list
  thumbprint_list = var.thumbprint_list
  tags = merge(
    { "Name" = var.name },
    var.tags,
  )
}

data "aws_iam_policy_document" "this_service" {
  count = local.service_policy_assume ? 1 : 0
  statement {
    sid     = "ServiceAssume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = var.service_name_to_assume
    }
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    sid = "TrustOIDC"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    principals {
      type = "Federated"
      identifiers = [
        local.aws_iam_openid_connect_provider_arn
      ]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = var.repo_ref
    }
  }
}

data "aws_iam_policy_document" "this_combined_policies" {
  source_policy_documents = concat(
    [data.aws_iam_policy_document.this.json],
  var.service_policy_assume == true ? [data.aws_iam_policy_document.this_service[0].json] : [])
}

data "aws_iam_policy_document" "this_s3" {
  count = local.s3_policy ? 1 : 0
  statement {
    actions = var.s3_bucket_actions
    resources = [
      "${var.s3_bucket_arn}${var.s3_bucket_path}/*",
      "${var.s3_bucket_arn}${var.s3_bucket_path}",
    ]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "this_s3_policy" {
  count       = local.s3_policy ? 1 : 0
  name        = "${var.name}_s3_bucket_policy"
  description = "Github action federated policy for S3 access"
  policy      = data.aws_iam_policy_document.this_s3[0].json
}

resource "aws_iam_role_policy_attachment" "this_s3_policy_attachment" {
  count      = local.s3_policy ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this_s3_policy[0].arn
}

data "aws_iam_policy_document" "this_ecr" {
  count = local.ecr_access ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = var.ecr_actions
    resources = var.ecr_repo_arn
  }
}

resource "aws_iam_policy" "this_ecr_policy" {
  count       = local.ecr_access ? 1 : 0
  name        = "${var.name}_ecr_policy"
  description = "Github action federated policy for ECR access"
  policy      = data.aws_iam_policy_document.this_ecr[0].json
}

resource "aws_iam_role_policy_attachment" "this_ecr_policy_attachment" {
  count      = local.ecr_access ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this_ecr_policy[0].arn
}

resource "aws_iam_role_policy_attachment" "this_custom_policy_attachment" {
  count      = length(local.custom_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = var.custom_policy_arns[count.index]
}

resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.this_combined_policies.json
  tags = merge(
    { "Name" = var.name },
    var.tags,
  )
}
