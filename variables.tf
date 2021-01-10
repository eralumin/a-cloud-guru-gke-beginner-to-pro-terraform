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

variable "region2" {
  type    = string
  default = "us-east1"
}

variable "region3" {
  type    = string
  default = "us-east4"
}

variable "region4" {
  type    = string
  default = "us-west1"
}

variable "region5" {
  type    = string
  default = "us-west2"
}

variable "region6" {
  type    = string
  default = "us-west3"
}

variable "zone" {
  type    = string
  default = "us-central1-c"
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
    "sqladmin.googleapis.com",
    "sql-component.googleapis.com",
  ]
}
