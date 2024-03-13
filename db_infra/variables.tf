variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "eu-west-3"
}

variable "docdb_cluster_identifier" {
  description = "Identifier for the DocDB cluster"
  type        = string
  default     = "my-docdb-cluster"
}

variable "docdb_engine" {
  description = "Engine type for the DocDB cluster"
  type        = string
  default     = "docdb"
}

variable "docdb_master_username" {
  description = "Master username for the DocDB cluster"
  type        = string
}

variable "docdb_master_password" {
  description = "Master password for the DocDB cluster"
  type        = string
}

variable "docdb_instance_class" {
  description = "Instance class for the DocDB instances"
  type        = string
  default     = "db.t4g.medium"
}

variable "cpu_utilization_threshold" {
  description = "CPU utilization threshold for triggering the alarm"
  type        = number
  default     = 80
}
