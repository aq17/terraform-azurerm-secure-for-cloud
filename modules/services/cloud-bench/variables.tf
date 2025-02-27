variable "resource_group" {
  type        = string
  description = "Pricing tier plan [Basic, Standard, Premium]"
}

variable "naming_prefix" {
  type        = string
  default     = "sysdigcloudbench"
  description = "Prefix for cloud bench resource names. Use the default unless you need to install multiple instances, and modify the deployment at the main account accordingly"

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-]+$", var.naming_prefix)) && length(var.naming_prefix) > 1 && length(var.naming_prefix) <= 64
    error_message = "Must enter a naming prefix up to 64 alphanumeric characters."
  }
}

variable "config_path" {
  type        = string
  description = "Configuration contents for the file stored in the bucket"
  default     = "default-cloud-bench.yaml"
}

variable "image" {
  type        = string
  default     = "sysdiglabs/cloud-bench:latest"
  description = "Image of the cloud bench to deploy"
}
