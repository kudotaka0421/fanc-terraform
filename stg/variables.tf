variable "db_username" {
  description = "The username for the database"
}

variable "db_password" {
  description = "The password for the database"
  sensitive   = true
}

variable "MYSQL_DATABASE" {}
variable "CORS_ALLOW_ORIGIN" {}
variable "MYSQL_PASSWORD" {}
variable "MYSQL_ROOT_PASSWORD" {}
variable "MYSQL_USER" {}
variable "SENDGRID_API_KEY" {}
variable "JWT_SECRET_KEY" {}
variable "MYSQL_HOST" {}
