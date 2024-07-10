# terraform-oidc-module
*Terraform module to manage identity provider in AWS*
### examples:
1. ***repo_ref***
In this example we can use our IAM role in Git branch ***main***
```
git branch example
repo_ref = ["repo:REPO_ORG/REPO_NAME:ref:refs/heads/main"]
```
###
In this example we can use our IAM role with Git ***tags***
```
git tags example
repo_ref = ["repo:REPO_ORG/REPO_NAME:ref:refs/tags/v*"]
```
##
2. Module create IAM role and trust relations with a conditional usage, role ARN can be used to attach any policy what we need to have in Github Aciton.
```
module "oidc" {
  source = "https://github.com/scribd/terraform-oidc-module"

  name = "example"
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["example0000example000example"]
  repo_ref = ["repo:REPO_ORG/REPO_NAME:ref:refs/heads/main"]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```
###
3. Module create IAM role and trust relations with a conditional usage, by default we will have also read only access into S3 bucket. Using ***s3_bucket_actions*** parameter we can have our own List of permissions.
If you want to use ***s3_bucket_path*** parameter please start it from slash like in example.
```
module "oidc" {
  source = "https://github.com/scribd/terraform-oidc-module"

  name = "example"
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["example0000example000example"]
  repo_ref = ["repo:REPO_ORG/REPO_NAME:ref:refs/heads/main"]

  s3_policy = true
  s3_bucket_arn = "example-bucket"
  # if s3_bucket_actions is not added then it defaults to S3 read only actions
  s3_bucket_actions = ["s3:Put", "s3:PutAcl"]
  s3_bucket_path = "/example"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```
###
4. Module create IAM role and trust relations with a conditional usage, by default we will have also read only access into ECR. Using ***ecr_actions*** parameter we can have our own List of permissions in ECR.
```
module "oidc" {
  source = "https://github.com/scribd/terraform-oidc-module"

  name = "example"
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["example0000example000example"]
  repo_ref = ["repo:REPO_ORG/REPO_NAME:ref:refs/heads/main"]
  
  # if ecr_access = true  next values a required  
  ecr_access = true
  # ecr_repo_arn  must be in ARN format or "*"
  ecr_repo_arn = [""]
  # if ecr_actions is not added then it defaults to ECR read only actions
  ecr_actions = [] 

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```
###
5. Module create IAM role and trust relations with a conditional usage. Using ***service_name_to_assume*** parameter we can add extra trust relation with an AWS service what we need.
```
module "oidc" {
  source = "https://github.com/scribd/terraform-oidc-module"

  name = "example"
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["example0000example000example"]
  repo_ref = ["repo:REPO_ORG/REPO_NAME:ref:refs/heads/main"]
  

  service_policy_assume = true
  service_name_to_assume =["sagemaker.amazonaws.com"]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```
###
6. Module create IAM role and trust relations with a conditional usage. Using ***custom_policy_arns*** parameter we can pass a list of IAM policy arns' what will be attached on to OIDC IAM role.
```
module "oidc" {
  source = "https://github.com/scribd/terraform-oidc-module"

  name = "example"
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["example0000example000example"]
  repo_ref = ["repo:REPO_ORG/REPO_NAME:ref:refs/heads/main"]
  
  custom_policy_arns = [aws_iam_policy.example_policy0.arn,aws_iam_policy.example_policy1.arn ]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```
###
3. Module do not create openid connect provider but use existing
```
resource "aws_iam_openid_connect_provider" "this" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["11111111111111111111111111"]
}

module "oidc" {
  source = "https://github.com/scribd/terraform-oidc-module"

  name = "example"
  url = "https://token.actions.githubusercontent.com"
  repo_ref = ["repo:REPO_ORG/REPO_NAME:ref:refs/heads/main"]
  use_existing_aws_iam_openid_connect_provider = true
  aws_iam_openid_connect_provider_arn = aws_iam_openid_connect_provider.this.arn
  s3_policy = true
  s3_bucket_arn = "example-bucket"
  # if s3_bucket_actions is not added then it defaults to S3 read only actions
  s3_bucket_actions = ["s3:Put", "s3:PutAcl"]
  s3_bucket_path = "/example"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```

##
Made with ❤️ by the Platform Infra Team.
