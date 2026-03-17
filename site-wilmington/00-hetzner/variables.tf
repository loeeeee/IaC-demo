# -----------------------------------------------------------------------------
# HETZNER CLOUD API CONNECTION VARIABLES
# These are the credentials needed to connect to the Hetzner Cloud API.
# -----------------------------------------------------------------------------

variable "hetzner_api_token" {
  type        = string
  description = "The Hetzner Cloud API token used for authentication."
  sensitive   = true
}

