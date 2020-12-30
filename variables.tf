variable "uid_prefix" {
  type = string
}

variable "billing_account" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-c"
}

variable "region2" {
  type    = string
  default = "us-east1"
}

variable "zone2" {
  type    = string
  default = "us-east1-c"
}

variable "services" {
  type    = list
  default = [
    "container.googleapis.com",
    "containerregistry.googleapis.com",
  ]
}
