# # =============================================================================
# # UCS 6536-FI Domain  (Config File)
# # 
# # Builds: Domain Cluster, Switch Profiles, X-Series Chassis Profiles and Policies
# #     
# # -----------------------------------------------------------------------------


module "intersight_pod1_domain_1" {                                             # <-- change when copying domain
  source = "github.com/bywhite/intersight-pod1-modules//imm-domain-fabric-6536-mod?ref=v1.0.0"

  # =============================================================================
  # External References
  # -----------------------------------------------------------------------------
  organization             = local.org_moid
  snmp_password            = var.snmp_password
  chassis_imc_ip_pool_moid = module.imm_pool_mod.ip_pool_chassis_moid

  # =============================================================================
  # Naming and tagging
  # -----------------------------------------------------------------------------

  # every policy created will have this prefix in its name
  policy_prefix = "${local.pod_policy_prefix}-domain-1"                           # <-- change when copying domain
  description   = "built by Terraform ${local.pod_policy_prefix}"

  #Every object created in the domain will have these tags
  tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "${local.pod_policy_prefix}" },
    { "key" : "domain", "value" : "${local.pod_policy_prefix}-domain-1" }         # <-- change when copying domain
  ]

  # =============================================================================
  # Chassis
  # -----------------------------------------------------------------------------

  chassis_9508_count = 5
  # Default chassis count is 5












  # chassis_imc_access_vlan    = 999
  # Chassis requires In-Band IP's Only  (ie must be a VLAN trunked to FI's)

  # =============================================================================
  # Fabric Interconnect 6536 Ethernet ports
  # -----------------------------------------------------------------------------
  # Uplink VLANs Allowed List    Example: "5,6,7,8,100-130,998-1011"
  # switch_vlans_6536 = "100,101,102,313,314,997-999"

  #FI ports to be used for ethernet port channel uplink
  # port_channel_6536 = [31, 32, 33, 34]

  # Number of physical ethernet ports to be used for 25G 4x breakout ports to chassis
  # eth_breakout_count = 0         # Must enumerate eth_aggr_server_ports when breakouts exist
  # eth_breakout_start = 29

  # FI physical port numbers to be attached to chassis 
  # server_ports_6536 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]

  # eth_aggr_server_ports = {
  #   "agg29-1"  = {  
  #       aggregate_port_id  = "29"
  #       port_id            = "1"
  #   }
  #   "agg29-2"  = {
  #       aggregate_port_id  = "29"
  #       port_id            = "2" 
  #   }
  #   "agg29-3"  = {   
  #       aggregate_port_id  = "29"
  #       port_id            = "3"
  #   }
  #   "agg29-4"  = {
  #       aggregate_port_id  = "29"
  #       port_id            = "4"
  #   }
  #   "agg30-1"  = {  
  #       aggregate_port_id  = "30"
  #       port_id            = "1"
  #   }
  #   "agg30-2"  = {
  #       aggregate_port_id  = "30"
  #       port_id            = "2"
  #   }
  #   "agg30-3"  = {
  #       aggregate_port_id  = "30"
  #       port_id            = "3"
  #   }
  #   "agg30-4"  = {
  #       aggregate_port_id  = "30"
  #       port_id            = "4"
  #   }
  # }

  # VLAN Prefix ex: vlan   >> vlan-230
  # vlan_prefix = "vlan"

  # =============================================================================
  # Fabric Interconnect 6536 FC Ports and VSANs
  # -----------------------------------------------------------------------------
  # 6536 FC capable ports are 33-36 (FC ports are on the right, slider starts at 36)

  # For each FC port, it is broken-out into 4x 32G FC Ports
  # A value of 2 results in 8x 32G FC Port breakouts from ports 35 & 36
  # fc_port_count_6536 = 2

  # VSAN ID for FC Port Channel
  # fc_uplink_pc_vsan_id_a = 100
  # fc_uplink_pc_vsan_id_b = 200



  # fc_port_channel_6536 = [
  #   { "aggport" : 35, "port" : 1 },
  #   { "aggport" : 35, "port" : 2 },
  #   { "aggport" : 35, "port" : 3 },
  #   { "aggport" : 35, "port" : 4 },
  #   { "aggport" : 36, "port" : 1 },
  #   { "aggport" : 36, "port" : 2 },
  #   { "aggport" : 36, "port" : 3 },
  #   { "aggport" : 36, "port" : 4 }
  # ]

  # VSAN Trunking is enabled by default. 
  # One or more VSANs are required for each FI

  # Fabric A VSAN Set
  # fabric_a_vsan_sets = {
  #   "vsan100" = {
  #     vsan_number   = 100
  #     fcoe_number   = 1000
  #     switch_id      = "A"
  #   }
  #   "vsan101"  = {
  #     vsan_number   = 101
  #     fcoe_number   = 1001
  #     switch_id      = "A"
  #   }
  # }

  # Fabric B VSAN Set
  #   fabric_b_vsan_sets = {
  #   "vsan200" = {
  #     vsan_number   = 200
  #     fcoe_number   = 2000
  #     switch_id      = "B"
  #   }
  #   "vsan201"  = {
  #     vsan_number   = 201
  #     fcoe_number   = 2001
  #     switch_id      = "B"
  #   }
  # }


  # =============================================================================
  # NTP, DNS and SNMP Settings
  # -----------------------------------------------------------------------------

  #ntp_servers   = ["ca.pool.ntp.org"]
  #ntp_timezone  = "America/Chicago"

  # dns_preferred = "8.8.8.8"
  # dns_alternate = "8.8.4.4"

  #snmp_ip       = "10.10.10.10"

  # The Pools for the Pod must be created before this domain fabric module executes
  depends_on = [
    module.imm_pool_mod, module.imm_pod_qos_mod
  ]

}
