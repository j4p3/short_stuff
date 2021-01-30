variable "name" {
  type        = string
  description = "Name of the application"
  default     = "shortstuff"
}

variable "environment_name" {
  type        = string
  description = "Current environment"
  default     = "development"
}

variable "aws_region" {
  type        = string
  description = "Region of the resources"
}

variable "aws_default_zone" {
  type        = string
  description = "The AWS region where the resources will be created"
}

variable "db_storage" {
  type        = string
  description = "Storage size for DB"
  default     = "8"
}

variable "db_engine" {
  type        = string
  description = "DB Engine"
  default     = "postgres"
}

variable "db_engine_version" {
  type        = string
  description = "Version of the database engine"
  default     = "12"
}

variable "db_instance_type" {
  type        = string
  description = "Type of the DB instance"
  default     = "db.t3.large"
}

variable "db_name" {
  type        = string
  description = "Name of the db"
}

variable "db_username" {
  type        = string
  description = "Name of the DB user"
}

variable "db_password" {
  type        = string
  description = "Name of the DB user"
}

variable "ecs_fargate_application_cpu" {
  type        = string
  description = "CPU units"
}

variable "ecs_fargate_application_mem" {
  type        = string
  description = "Memory value"
}

variable "ecs_application_count" {
  type        = number
  description = "Container count of the application"
  default     = 1
}
