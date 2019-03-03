provider "aws" {
  region = "eu-central-1"
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "lauf-gegen-rechts-terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "DynamoDB Terraform State Lock Table"
  }
}

resource "aws_s3_bucket" "lauf-gegen-retchs-state-bucket" {
  bucket = "lauf-gegen-rechts-state-bucket"
  acl    = "private"
}
