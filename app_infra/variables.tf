variable "aws_region" {
  description = "The AWS region."
  type        = string
  default     = "eu-north-1"
}

variable "aws_account_id" {
  description = "The AWS account ID."
  type        = string
}

variable "image_tag" {
  description = "The tag of the Docker image."
  type        = string
  default     = "latest"
}

variable "image_repo_name" {
  description = "The name of the ECR repository."
  type        = string
}

variable "image_repo_url" {
  default = "<account-id>.dkr.ecr.<region>.amazonaws.com/<repository>"
}

variable "github_repo_owner" {
  description = "The GitHub repository owner."
  type        = string
  default     = "MaximePETIT-code"
}

variable "github_repo_name" {
  description = "The GitHub repository name."
  type        = string
  default     = "glowing-dollop"
}

variable "github_branch" {
  description = "The branch in the GitHub repository to use."
  type        = string
  default     = "main"
}

variable "github_oauth_token" {
  description = "OAuth token for GitHub authentication."
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "The name of the ECS Cluster."
  type        = string
}

variable "service_name" {
  description = "The name of the ECS Service."
  type        = string
}

variable "file_name" {
  description = "The file name of the image definitions."
  type        = string
  default     = "imagedefinitions.json"
}
