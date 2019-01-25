variable "domain_name" {}
variable "app_name" {}
variable "subnet_ids" {
  type = "list"
  default = []
}
variable "vpc_id" {}
variable "redis" {}
variable "postgres" {}
