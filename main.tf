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
  app_name = "${var.app_name}"
}

module "ec2" {
  source = "./ec2"
  domain_name ="${var.domain_name}"
  app_name = "${var.app_name}"
  subnet_ids = ["${module.vpc.ec2-subnet-id-1}", "${module.vpc.ec2-subnet-id-2}"]
  vpc_id = "${module.vpc.id}"
  redis = "${module.persistence.redis-ip}"
  postgres = "${module.persistence.postgres-ip}"
}

module "persistence" {
  source             = "./persistence"
  redis-subnet-id    = "${module.vpc.redis-subnet-id}"
  db-subnet-id-1     = "${module.vpc.db-subnet-id-1}"
  db-subnet-id-2     = "${module.vpc.db-subnet-id-2}"
  app_name           = "${var.app_name}"
  security-group-id  = "${module.ec2.ec2-security-group-id}"
  vpc-id             = "${module.vpc.id}"
  config-bucket-name = "${var.domain_name}-config-bucket"
}

