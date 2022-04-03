variable "vpc_id" {
  type = string
}

variable "elbsubnets" {
  type = list
}
variable "asg_subnets" {
  type = list
}
variable "albsecuritygroups" {
  type = list
}

variable "appsecurtiygroup" {
  type = list(any)
}
variable "database_name" {
  type = string
}
variable "db_writer_endpoint" {
  type = string
}
variable "database_username" {
  type = string
}
variable "database_password" {
  type = string
}
variable "efs_id" {
  type = string
}