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

output "heroku_app_id" {
  value = "${heroku_app.playtime.id}"
}

output "heroku_url" {
  value = "${heroku_app.playtime.web_url}"
}
