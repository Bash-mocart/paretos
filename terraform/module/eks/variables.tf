variable "region" {
    default = "us-east-1"
    type = string
}

variable "vpc-cidr" {
    default = "192.168.0.0/16"
    type = string
}

variable "pub-subnet-cidr-a" {
    default = "192.168.0.0/18"
    type = string
}

variable "pub-subnet-cidr-b" {
    default = "192.168.64.0/18"
    type = string
}


variable "pri-subnet-cidr-a" {
    default = "192.168.128.0/18"
    type = string
}

variable "pri-subnet-cidr-b" {
    default = "192.168.192.0/18"
    type = string
    
}


variable "db_name" {
  type    = string
  default = "postgres"
}

variable "db_engine" {
  type    = string
  default = "postgres"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}


variable "az-a" {
    type = string
}

variable "az-b" {
    type = string
}








