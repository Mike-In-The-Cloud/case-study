variable "instanceclass" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "dbengine_type" {
  type = string  
}

variable "dbengine_version" {
  type = string  
}

variable "db_subnet_group" {
  type = string  
}

variable "db_security_group" {
  type = list 
}

variable "cache_engine" {
  type = string  
}

variable "cache_node_type" {
  type = string  
}

variable "cache_parameter_group" {
  type = string  
}

variable "cache_security_group" {
  type = list  
}

variable "cache_subnet_group" {
  type = string  
}