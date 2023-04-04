# Variables are used to increase code re-use and improve security of sensitive data through abstraction

# Sensitive information should be stored in variables (var.<variable>) to be passed in from external sources
#    Terraform Variables can be passed in from TFCB, CLI apply parameters and environment variables (TF_VAR_<var-name>)

#  All Main Module variables listed should be Set in TFCB "Workspace" > "Variables"
#  The following are defined as variables in the designated TFCB workspace
#       endpoint (http://intersight.com)
#       api_key  (ID for Intersight)
#       secretkey (Key for Intersight)
#       imc_admin_password


# https://intersight.com/an/settings/api-keys/
## Generate API key to obtain the API key and secret key
variable "api_key" {
    description = "API key for Intersight account"
    type = string
}

variable "secretkey" {
    description = "Filename that provides secret key for Intersight API"
    type = string
}

# This is the Intersight URL (could be URL to Intersight Private Virtual Appliance instead)
variable "endpoint" {
    description = "Intersight API endpoint"
    type = string
    default = "https://intersight.com"
}

# This is the target organization defined in Intersight to be configured
variable "organization" {
    type = string
    default = "default"
}

variable "imc_admin_password" {
    type = string
}
variable "snmp_password" {
    type = string
}
