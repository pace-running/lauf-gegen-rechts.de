provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "lauf-gegen-rechts-state-bucket"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-lock-dynamo"
    key            = "terraform.tfstate"
  }
}

module "vpc" {
  source = "./vpc"
}

module "domain" {
  source = "./domain"
  domain_name        = "${var.domain_name}"
 // load-balancer-name = "${module.ec2.ecs-load-balancer-dns-name}"
}

module "persistence" {
  source             = "./persistence"
  redis-subnet-id    = "${module.vpc.redis-subnet-id}"
  db-subnet-id-1     = "${module.vpc.db-subnet-id-1}"
  db-subnet-id-2     = "${module.vpc.db-subnet-id-2}"
  app_name           = "${var.app_name}"
  security-group-id  = "${module.vpc.security-group-id}"
  vpc-id             = "${module.vpc.id}"
  config-bucket-name = "${var.domain_name}-config-bucket"
}

