terraform {
  backend "s3" {}
}

provider "aws" {
  region  = "us-east-1"
  profile = "${var.aws_profile}"
}

provider "heroku" {
  email   = "${var.heroku_email}"
  api_key = "${var.heroku_api_key}"
}

variable "heroku_email" {
  type        = "string"
  description = "The email address associated with the Heroku account in use"
}

variable "heroku_api_key" {
  type        = "string"
  description = "The Heroku API associated with the Heroku email"
}

variable "aws_profile" {
  type        = "string"
  description = "The AWS profile which contains credentials to store state in S3"
}

resource "heroku_app" "playtime" {
  name   = "playtime-project-01"
  region = "us"

  config_vars {
    RAILS_ENV = "production"
    PORT      = 80
  }

  buildpacks = [
    "heroku/ruby",
  ]
}

resource "heroku_addon" "database" {
  app  = "${heroku_app.playtime.name}"
  plan = "heroku-postgresql:hobby-dev"
}

resource "aws_iam_user" "playtime" {
  name = "playtime"
}

data "aws_iam_policy_document" "aws_product_api" {
  statement {
    sid    = "awsProductApi"
    effect = "Allow"

    not_actions = [
      "acm:*",
      "apigateway:*",
      "application-autoscaling:*",
      "appstream:*",
      "autoscaling:*",
      "aws-marketplace:*",
      "aws-portal:*",
      "batch:*",
      "clouddirectory:*",
      "cloudformation:*",
      "cloudfront:*",
      "cloudhsm:*",
      "cloudsearch:*",
      "cloudtrail:*",
      "cloudwatch:*",
      "codebuild:*",
      "codecommit:*",
      "codedeploy:*",
      "codepipeline:*",
      "codestar:*",
      "cognito-identity:*",
      "cognito-sync:*",
      "config:*",
      "connect:*",
      "datapipeline:*",
      "devicefarm:*",
      "directconnect:*",
      "discovery:*",
      "dms:*",
      "ds:*",
      "dynamodb:*",
      "ec2:*",
      "ecr:*",
      "ecs:*",
      "elasticache:*",
      "elasticbeanstalk:*",
      "elasticfilesystem:*",
      "elasticloadbalancing:*",
      "elasticmapreduce:*",
      "elastictranscoder:*",
      "es:*",
      "events:*",
      "execute-api:*",
      "firehose:*",
      "gamelift:*",
      "glacier:*",
      "health:*",
      "iam:*",
      "importexport:*",
      "inspector:*",
      "iot:*",
      "kinesis:*",
      "kms:*",
      "lambda:*",
      "lightsail:*",
      "logs:*",
      "machinelearning:*",
      "mechanicalturk:*",
      "mobileanalytics:*",
      "mobilehub:*",
      "mobiletargeting:*",
      "opsworks:*",
      "organizations:*",
      "polly:*",
      "rds:*",
      "redshift:*",
      "rekognition:*",
      "route53:*",
      "route53domains:*",
      "s3:*",
      "sdb:*",
      "ses:*",
      "shield:*",
      "sns:*",
      "sqs:*",
      "ssm:*",
      "states:*",
      "storagegateway:*",
      "sts:*",
      "support:*",
      "swf:*",
      "trustedadvisor:*",
      "waf-regional:*",
      "waf:*",
      "wam:*",
      "workdocs:*",
      "workmail:*",
      "workspaces:*",
      "xray:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_user_policy" "aws_product_api" {
  name   = "playtime"
  user   = "${aws_iam_user.playtime.name}"
  policy = "${data.aws_iam_policy_document.aws_product_api.json}"
}

output "heroku_app_id" {
  value = "${heroku_app.playtime.id}"
}

output "heroku_url" {
  value = "${heroku_app.playtime.web_url}"
}
