variable "subscription_id" {
  type        = string
  description = "Subscription ID where apply the infrastructure"
}

variable "sysdig_secure_api_token" {
  type        = string
  description = "Sysdig's Secure API Token"
  sensitive   = true
}

variable "sysdig_secure_endpoint" {
  type        = string
  default     = "https://secure-staging.sysdig.com/"
  description = "Sysdig's Secure API URL"
}

variable "verify_ssl" {
  type        = bool
  default     = true
  description = "Verify the SSL certificate of the Secure endpoint"
}

variable "naming_prefix" {
  type        = string
  default     = "cloudconnector"
  description = "Prefix for cloud scanning resource names. Use the default unless you need to install multiple instances, and modify the deployment at the main account accordingly"

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-]+$", var.naming_prefix)) && length(var.naming_prefix) > 1 && length(var.naming_prefix) <= 64
    error_message = "Must enter a naming prefix up to 64 alphanumeric characters."
  }
}

variable "config_file" {
  type        = string
  description = "Configuration contents for the file stored in the bucket"
  default     = "cloud-connector.yml"
}

variable "image" {
  type        = string
  default     = "sysdiglabs/cloud-connector:latest"
  description = "Image of the cloud-scanning to deploy"
}

variable "location" {
  type        = string
  default     = "centralus"
  description = "Zone where the stack will be deployed"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be added to the resources"
  default = {
    Team = "Sysdig"
  }
}