data "aws_iam_policy_document" "rk-dev-terraform-state-bucket" {
  statement {
    actions = [
      "s3:*",
    ]
    effect = "Deny"
    resources = [
      "arn:aws:s3:::${var.rk_data_bucket}",
    ]

    condition {
      test     = "StringNotLike"
      variable = "aws:SourceVpce"

      values = [
        "${module.vpc.vpc_endpoint_s3_id}",

      ]
    }
  }
}





module "rk_data_bucket" {
  source                  = "terraform-aws-modules/s3-bucket/aws"
  version                 = "1.17.0"
  bucket                  = var.rk_data_bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  force_destroy           = true
  #policy                  = data.aws_iam_policy_document.rk_data_bucket_policy.json

  tags = {
    "Terraform"   = "true",
    "Environment" = "dev"

  }
}




