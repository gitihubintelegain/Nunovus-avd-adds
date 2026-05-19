########################################
# VM Credentials
########################################

variable "admin_username" {
  description = "Local administrator username for AVD session hosts"
  type        = string
}

variable "admin_password" {
  description = "Local administrator password for AVD session hosts"
  type        = string
  sensitive   = true
}
