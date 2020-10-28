variable "project_id" {
  type = string
  description = "The GCP project to deploy the resources to."
}

variable "project_number" {
  type = string
  description = "The GCP project number."
}

variable "environment" {
  type = string
  description = "Env name."
}

variable "git_repo" {
  type = string
  description = "Git repository."
}

variable "region" {
  type = string
  description = "The default region to deploy the resources to."
}

variable "zone" {
  type = string
  description = "The default zone to deploy the resources to."
}

variable "sql_user" {
  type = object({
    username = string
    password = string
  })
  description = "The app's credentials."
}

variable "sql_db_name" {
  type = string
  description = "The app's database name."
}
