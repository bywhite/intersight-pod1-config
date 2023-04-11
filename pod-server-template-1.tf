# # =============================================================================
# # This defines a single Server Profile Template using a remote module
# #    * Note: Derivation of Server Profiles is outside of TF scope
# # Duplicate this code/file to add another Server Template and
# #    * Change module alias: "server_template_1"  >> "server_template_2"
# #    * Change server_policy_prefix: "...-vmw1" > "...-vmw2"
# #    * Change Tag value for "ServerGroup" to include new name
# #    * Modify parameters as needed to tweak your template configuration
# # -----------------------------------------------------------------------------


module "server_template_1" {                                                  # <<-- Change to duplicate template
  source = "github.com/bywhite/intersight-pod1-modules//imm-pod-servers"
            # remote module name above should not be changed when duplicating

# =============================================================================
# External Common References
# -----------------------------------------------------------------------------
  organization              = local.org_moid      #Intersight Organaization to use
  mac_pool_moid             = module.imm_pool_mod.mac_pool_moid
  imc_ip_pool_moid          = module.imm_pool_mod.ip_pool_moid
  wwnn_pool_moid            = module.imm_pool_mod.wwnn_pool_moid
  wwpn_pool_a_moid          = module.imm_pool_mod.wwpn_pool_a_moid
  wwpn_pool_b_moid          = module.imm_pool_mod.wwpn_pool_b_moid
  server_uuid_pool_moid     = module.imm_pool_mod.uuid_pool_moid
  server_uuid_pool_name     = module.imm_pool_mod.uuid_pool_name
  snmp_password             = var.snmp_password
  server_imc_admin_password = var.imc_admin_password
  user_policy_moid          = intersight_iam_end_point_user_policy.pod_user_policy_1.moid

# =============================================================================
# Naming and tagging
# -----------------------------------------------------------------------------
  # prefix for all created policies
  server_policy_prefix = "${local.pod_policy_prefix}-vmw1"                    # <<-- Change to duplicate template
  description          = "built by Terraform ${local.pod_policy_prefix}"

  #Every object created in the domain will have these tags
  tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "${local.pod_policy_prefix}" },
    { "key" : "ServerTemplate", "value" : "${local.pod_policy_prefix}-vmw1" }  # <-- Change to duplicate template
  ]

# =============================================================================
# X vs B Chassis Profile Customizations
# -----------------------------------------------------------------------------
# Customize policies for X-Series (true) or B-Series (false)
  is_x_series_profile = true 

# =============================================================================
# Server Eth vNic's & FC vHBA's Options
# -----------------------------------------------------------------------------
# Ensure "pci_order is unique and sequential across all vnic/vhba"
# Ensure vlans & vsans are provisioned on target UCS Domain, use depends_on

  vnic_vlan_sets = {
    "eth0"  = {
      vnic_name   = "eth0"
      native_vlan = 21
      vlan_range  = "21,60,254,255"
      switch_id   = "A"
      pci_order   = 0
      qos_moid    = module.imm_pod_qos_mod.vnic_qos_besteffort_moid
    }
    "eth1"  = {
      vnic_name   = "eth1"
      native_vlan = 21
      vlan_range  = "21,60,254,255"
      switch_id   = "B"
      pci_order   = 1
      qos_moid    = module.imm_pod_qos_mod.vnic_qos_besteffort_moid
    }
  }


  vhba_vsan_sets = {
    "fc0" = {
      vhba_name      = "fc0"
      vsan_moid      = intersight_vnic_fc_network_policy.fc_vsan_101.moid
      switch_id      = "A"
      wwpn_pool_moid = module.imm_pool_mod.wwpn_pool_a_moid
      pci_order      = 2
      qos_moid       = module.imm_pod_qos_mod.vnic_qos_fc_moid
    }
    "fc1"  = {
      vhba_name      = "fc1"
      vsan_moid      = intersight_vnic_fc_network_policy.fc_vsan_102.moid
      switch_id      = "B"
      wwpn_pool_moid = module.imm_pool_mod.wwpn_pool_b_moid
      pci_order      = 3
      qos_moid       = module.imm_pod_qos_mod.vnic_qos_fc_moid
    }
  }

 
# =============================================================================
# Dependencies
# -----------------------------------------------------------------------------
# The Pools for the Pod must be created before this domain fabric module executes
  depends_on = [
    module.imm_pool_mod, intersight_iam_end_point_user_policy.pod_user_policy_1,
    module.imm_pod_qos_mod, module.intersight_pod1_domain_1,
    intersight_vnic_fc_network_policy.fc_vsan_100, intersight_vnic_fc_network_policy.fc_vsan_200
  ]

}