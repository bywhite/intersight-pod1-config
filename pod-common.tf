# =============================================================================
# COMMON objects shared throughout Pool for simplified Pod management:
#   - IMC Local User Policies
#   - Pod Server VSAN Policies
#   - QoS Policies for UCS Domain and Server Templates
#   - Pod Pools: IP, MAC, UUID, WWNN, WWPN
# =============================================================================
# =============================================================================



# =============================================================================
# COMMON IMC Local User Policies
# -----------------------------------------------------------------------------
# IMC Policies are Consumed by Sever Profile Templates with:
# IMC User Policy  
#   policy_bucket {
#     moid = intersight_iam_end_point_user_policy.pod_user_policy_1.moid
#     object_type = "iam.EndPointUserPolicy"
#   }

## Standard Local User Policy for all local IMC users
resource "intersight_iam_end_point_user_policy" "pod_user_policy_1" {
  description = "Local IMC User Policy"
  name        = "${local.pod_policy_prefix}-imc-user-policy1"
  password_properties {
    enforce_strong_password  = false
    enable_password_expiry   = false
    password_expiry_duration = 90
    password_history         = 0
    notification_period      = 15
    grace_period             = 0
    object_type              = "iam.EndPointPasswordProperties"
  }
  organization {
    moid        = local.org_moid
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = local.pod_tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

##  Admin user
# This resource is a user that will be added to the policy.
resource "intersight_iam_end_point_user" "admin1" {
  name = "admin"
  organization {
    moid        = local.org_moid
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = local.pod_tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# This data source retrieves a system built-in role that we want to assign to the admin user.
data "intersight_iam_end_point_role" "imc_admin" {
  name      = "admin"
  role_type = "endpoint-admin"
  type      = "IMC"
}

# This resource adds the user to the policy using the role we retrieved.
# Notably, the password is set in this resource and NOT in the user resource above.
resource "intersight_iam_end_point_user_role" "admin1" {
  enabled  = true
  password = var.imc_admin_password
  end_point_user {
    moid = intersight_iam_end_point_user.admin1.moid
  }
  end_point_user_policy {
    moid = intersight_iam_end_point_user_policy.pod_user_policy_1.moid
  }
  end_point_role {
    moid = data.intersight_iam_end_point_role.imc_admin.results[0].moid

  }
  dynamic "tags" {
    for_each = local.pod_tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
  depends_on = [
    intersight_iam_end_point_user.admin1, intersight_iam_end_point_user_policy.pod_user_policy_1
  ]
}

## Example Read Only user
# This resource is a user that will be added to the policy.
resource "intersight_iam_end_point_user" "ro_user1" {
  name = "ro-user1"

  organization {
    moid        = local.org_moid
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = local.pod_tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# This data source retrieves a system built-in role that we want to assign to the user.
data "intersight_iam_end_point_role" "imc_readonly" {
  name      = "readonly"
  role_type = "endpoint-readonly"
  type      = "IMC"
}

# This user gets a random password that can be reset later
resource "random_password" "example_password" {
  length  = 16
  special = false
}

# This resource adds the user to the policy using the role we retrieved.
# Notably, the password is set in this resource and NOT in the user resource above.
resource "intersight_iam_end_point_user_role" "ro_user1" {
  enabled  = true
  password = var.imc_admin_password
  # Alternatively, we could assign a random passwrod to be changed later
  # password = random_password.example_password.result
  end_point_user {
    moid = intersight_iam_end_point_user.ro_user1.moid
  }
  end_point_user_policy {
    moid = intersight_iam_end_point_user_policy.pod_user_policy_1.moid
  }
  end_point_role {
    moid = data.intersight_iam_end_point_role.imc_readonly.results[0].moid
  }
  dynamic "tags" {
    for_each = local.pod_tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# =============================================================================
# COMMON Pod Server VSAN Policies
#  - Creates vNic vSAN Policies for use Pod-wide
#  - This must match up with domain fabric's (FI's) vSAN Policies
# -----------------------------------------------------------------------------


resource "intersight_vnic_fc_network_policy" "fc_vsan_100" {
  name        = "${local.pod_policy_prefix}-fc-vsan-100"
  description = local.description
  vsan_settings {
    id          = 100
    object_type = "vnic.VsanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}

resource "intersight_vnic_fc_network_policy" "fc_vsan_101" {
  name        = "${local.pod_policy_prefix}-fc-vsan-101"
  description = local.description
  vsan_settings {
    id          = 101
    object_type = "vnic.VsanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}

resource "intersight_vnic_fc_network_policy" "fc_vsan_102" {
  name        = "${local.pod_policy_prefix}-fc-vsan-102"
  description = local.description
  vsan_settings {
    id          = 102
    object_type = "vnic.VsanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}

resource "intersight_vnic_fc_network_policy" "fc_vsan_200" {
  name        = "${local.pod_policy_prefix}-fc-vsan-200"
  description = local.description
  vsan_settings {
    id          = 200
    object_type = "vnic.VsanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}

resource "intersight_vnic_fc_network_policy" "fc_vsan_201" {
  name        = "${local.pod_policy_prefix}-fc-vsan-201"
  description = local.description
  vsan_settings {
    id          = 201
    object_type = "vnic.VsanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}

resource "intersight_vnic_fc_network_policy" "fc_vsan_202" {
  name        = "${local.pod_policy_prefix}-fc-vsan-202"
  description = local.description
  vsan_settings {
    id          = 202
    object_type = "vnic.VsanSettings"
  }
  organization {
    object_type = "organization.Organization"
    moid        = local.org_moid
  }
}

# =============================================================================
# UCS Domain and Server Related QoS Policies
#  - Creates vNic QoS Policies for each class of service
#  - This must match up with domain fabric's System QoS Policy
# -----------------------------------------------------------------------------

# # Due to policy bucket limitations, the default System QoS policy must be created with Switch Profile's moids attached.
# # Accordingly, the resource "intersight_fabric_system_qos_policy" is created with the domain fabric module instead of this module.


module "imm_pod_qos_mod" {
  source = "github.com/bywhite/intersight-pod1-modules//imm-pod-server-qos-mod"

  # =============================================================================
  # Org external references
  # -----------------------------------------------------------------------------

  org_id = local.org_moid

  # =============================================================================
  # Naming and tagging
  # -----------------------------------------------------------------------------

  # Every QoS policy created will have this prefix in its name
  policy_prefix = local.pod_policy_prefix

  # This is the default description for IMM objects created
  description = "built by Terraform for ${local.pod_policy_prefix}"

  #Every object created in the domain will have these tags
  tags = local.pod_tags

}

# =============================================================================
# COMMON Pod Pools
#   - IP Pool for IMC
#   - MAC Pool for Server Templates vNic's
#   - UUID Pool for Server Templates
#   - WWNN Pool for Server Templates vHBA's
#   - WWPN Pool for Server Templates vHBA's
# -----------------------------------------------------------------------------
# Create a sequential IP pool for IMC access. Change the from and size to what you would like
# Mac tip: Use CMD+K +C to comment out blocks.   CMD+K +U will un-comment blocks of code

module "imm_pool_mod" {
  source = "github.com/bywhite/intersight-pod1-modules//imm-pod-pools-mod"

  # external sources
  organization = local.org_moid

  # every policy created will have this prefix in its name
  policy_prefix = local.pod_policy_prefix
  description   = local.description

#IP's used for Richfield Lab ACI-KVM-InBand
  ip_size        = "4"
  ip_start       = "198.18.101.90"
  ip_gateway     = "198.18.101.254"
  ip_netmask     = "255.255.255.0"
  ip_primary_dns = "10.101.128.15"

  chassis_ip_size        = "2"
  chassis_ip_start       = "198.18.101.94"
  chassis_ip_gateway     = "198.18.101.254"
  chassis_ip_netmask     = "255.255.255.0"
  chassis_ip_primary_dns = "10.101.128.16"


# IP's used for dCloud Demo Environment
  # ip_size        = "8"
  # ip_start       = "198.18.0.100"
  # ip_gateway     = "198.18.0.1"
  # ip_netmask     = "255.255.255.0"
  # ip_primary_dns = "198.18.133.1"

  # chassis_ip_size        = "2"
  # chassis_ip_start       = "198.18.0.108"
  # chassis_ip_gateway     = "198.18.0.1"
  # chassis_ip_netmask     = "255.255.255.0"
  # chassis_ip_primary_dns = "198.18.133.1"

  pod_id = local.pod_id
  # used to create moids for Pools: MAC, WWNN, WWPN

  tags = [
    { "key" : "Environment", "value" : "dev" },
    { "key" : "Orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "ofl-dev-pod1" }
  ]
}
