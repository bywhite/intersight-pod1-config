# ==========================================================================================
# The purpose of this module is to create a single Pod of Multiple IMM Domains
# The Pod is similar to a VPC in that it has shared network & storage resources
# The pod uses a common set of large pools of identifiers (UUID, MAC, WWNN, WWPN, IMC-IP's)
#     - pod-domain config files define each IMM domain with its chassis
#     - pod-common config file defines the pod-wide shared pools and policies (like QoS, IMC Users)
#     - pod-srv-template config files create server profile templates
# When Pod folder copied, change pod name and ID in locals.tf
# ------------------------------------------------------------------------------------------
# demo backend: name = "intersight-dc1-pod1"
# dCloud backend: name = "dcloud"

terraform {

  backend "remote" {
    organization = "bywhite"

    workspaces {
      name = "dcloud"
    }
  }

  #Setting required version "=" to eliminate any future adverse behavior without testing first
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">1.0.34"
    }
  }
}

provider "intersight" {
  apikey    = var.apikey
  secretkey = var.secretkey
  endpoint  = var.endpoint
}

#Organizations should be created manually in Intersight and changed below for each Data Center
# Example Use:  org_moid = data.intersight_organization_organization.my_org.id
data "intersight_organization_organization" "my_org" {
  name = var.organization
}

# IMM Code Examples Can Be Found at:
# https://github.com/jerewill-cisco?tab=repositories
# https://github.com/bywhite/tf-imm-pod-example-code
# https://github.com/terraform-cisco-modules/terraform-intersight-imm/tree/master/modules

