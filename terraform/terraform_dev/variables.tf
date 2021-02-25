variable "name" {
  type        = string
  description = "Name of the application"
  default     = "shortstuff"
}

variable "environment" {
  type        = string
  description = "Current environment"
  default     = "dev"
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

variable "db_password" {
  type        = string
  description = "Password of the DB user"
}

variable "secret_key_base" {
  type        = string
  description = "Phoenix security value"
}

variable "admin_user" {
  type        = string
  description = "Email of default admin"
}

variable "admin_password" {
  type        = string
  description = "Password of default admin"
}

variable "signing_salt" {
  type        = string
  description = "Phoenix security value"
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

variable "hostname" {
  type = string
  description = "Phoenix endpoint config"
}
variable "asset_host" {
  type = string
  description = "Phoenix endpoint config"
}

variable "twilio_account_id" {
  type = string
  description = "Twilio API credential"
}

variable "twilio_auth_token" {
  type = string
  description = "Twilio API credential"
}

variable "twilio_notify_service_id" {
  type = string
  description = "Twilio API credential"
}

variable "aws_acm_certificate" {
  type = string
  description = "ARN of ACM cert for CDN"
}