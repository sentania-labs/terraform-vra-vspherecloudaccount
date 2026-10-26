variable "name" {
  type        = string
  description = "The name of the cloud account"
}

variable "capability_tags" {
  type = list(object({
    key   = string
    value = string
  }))
  description = "Capability tags to be applied to the Cloud Account, as a list of key/value objects"
  default     = []

  validation {
    condition     = alltrue([for t in var.capability_tags : trimspace(t.key) != ""])
    error_message = "Every capability tag must have a non-empty key."
  }
}

variable "description" {
  type        = string
  default     = "Managed by TF - Do not edit!"
  description = "A description for the cloud account"
}

variable "hostname" {
  type        = string
  description = "The FQDN of the vcenter server (hostname only, no scheme or path)"

  validation {
    condition     = trimspace(var.hostname) != "" && !can(regex("[/:\\s]", var.hostname))
    error_message = "hostname must be a bare FQDN or IP address, without a scheme, port, or path."
  }
}

variable "username" {
  type        = string
  description = "The username for the service account"

  validation {
    condition     = trimspace(var.username) != ""
    error_message = "username must not be empty."
  }
}

variable "password" {
  type        = string
  description = "The password for the service account"
  sensitive   = true

  validation {
    condition     = var.password != ""
    error_message = "password must not be empty."
  }
}

variable "accept_self_signed_cert" {
  type        = bool
  default     = true
  description = "Accept self-signed vCenter certificates. Applied to both the region enumeration data source and the cloud account resource; set to false to require a certificate trusted by the vRA/Aria Automation host."
}

variable "enabled_datacenters" {
  type        = list(string)
  description = "An array of vSphere Datacenters to enable for automation"
}

variable "nsx_manager" {
  default     = ""
  type        = string
  description = "The NSX manager connected to this vCenter"
}
