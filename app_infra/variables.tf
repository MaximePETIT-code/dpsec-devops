variable "github_repo_owner" {
  default = "DC-spec-data"
}

variable "github_repo_name" {
  default = "dc-infra"
}

variable "github_branch" {
  default = "master"
}

variable "github_oauth_token" {
  type        = string
  description = "OAuth token for GitHub authentication"
}