# # =============================================================================
# # UCS 6454-FI Domain  (Config File)
# # 
# # Builds: Domain Profile with Chassis Profiles and their Policies
# #         configured for 6454 FI and 9508 chassis
# # -----------------------------------------------------------------------------


module "intersight_pod1_domain_2" {                                            # <-- Change when copied
  source = "github.com/bywhite/intersight-pod1-modules//imm-domain-fabric-6454-mod" #?ref=v1.1.0"

# =============================================================================
# Org external references
# -----------------------------------------------------------------------------

  # external sources
  organization = local.org_moid

# =============================================================================
# Naming and tagging
# -----------------------------------------------------------------------------

  # every policy created will have this prefix in its name
  policy_prefix = "${local.pod_policy_prefix}-dom2"                            # <-- Change when copied
  description   = "built by Terraform ${local.pod_policy_prefix}"

  #Every object created in the domain will have these tags
  tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "${local.pod_policy_prefix}" },
  ]

#FI Assignments
# fi_a_sn = "FDO244000GQ"
# fi_b_sn = "FDO2440009A"
fi_model = "UCS-FI-64108"   # Options "UCS-FI-6454" or "UCS-FI-64108"

# =============================================================================
# Fabric Interconnect 6545 Ethernet ports
# -----------------------------------------------------------------------------
# Configured for dCloud FI's

  #FI ports to be used for ethernet port channel uplink
  # port_channel_6454 = [48]   #dcloud
  port_channel_6454 = [105]   # Richfield 64108
  #  port_channel_6454 = [49,50,51,52]

  # FI physical port numbers to be attached to chassis 
  # server_ports_6454 = [17,18]  #dcloud
  server_ports_6454 = [65,67]    # Richfiled 64108
  #server_ports_6454 = [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44]

  # VLAN Prefix ex: vlan   >> name is: vlan-230
  vlan_prefix = "vlan"

  # Uplink VLANs Allowed List    Example: "5,6,7,8,100-130,998-1011"
  # switch_vlans_6454 = "5-7,10" #dcloud
  switch_vlans_6454 = "101-103,201-250,1000-1199"  # Richfield "101-103,201-250,1000-1199"

# =============================================================================
# Fabric Interconnect 6454 FC Ports and VSANs
# -----------------------------------------------------------------------------
    #6454 & 64108 FC ports start at Port 1 up to 16 (FC on left of slider)

  # A value of 8 results in 8x 32G FC Port from ports 1 to 8
  fc_port_count_6454 = 8

  # VSAN ID for FC Port Channel
  fc_uplink_pc_vsan_id_a = 100
  fc_uplink_pc_vsan_id_b = 200

  #dCloud Config
  #   fc_port_channel_6454 = [
  #   { "aggport" : 0, "port" : 1 },
  #   { "aggport" : 0, "port" : 2 },
  #   { "aggport" : 0, "port" : 3 },
  #   { "aggport" : 0, "port" : 4 },
  #   { "aggport" : 0, "port" : 5 },
  #   { "aggport" : 0, "port" : 6 },
  #   { "aggport" : 0, "port" : 7 },
  #   { "aggport" : 0, "port" : 8 }
  # ]
    fc_port_channel_6454 = [
    { "aggport" : 0, "port" : 1 },
    { "aggport" : 0, "port" : 3 }
  ]

# VSAN Trunking is enabled by default. One or more VSANs are required for each FI

  # Fabric A VSAN Set
  fabric_a_vsan_sets = {
    "vsan100" = {
      vsan_number   = 100
      fcoe_number   = 1000
      switch_id      = "A"
    }
    # "vsan101"  = {
    #   vsan_number   = 101
    #   fcoe_number   = 1001
    #   switch_id      = "A"
    # }
  }

  # Fabric B VSAN Set
    fabric_b_vsan_sets = {
    "vsan200" = {
      vsan_number   = 200
      fcoe_number   = 2000
      switch_id      = "B"
    }
    # "vsan201"  = {
    #   vsan_number   = 201
    #   fcoe_number   = 2001
    #   switch_id      = "B"
    # }
  }

# =============================================================================
# Chassis
# -----------------------------------------------------------------------------

  chassis_9508_count       = 1
  chassis_imc_access_vlan  = 101     #dcloud is 10   richfield aci-kvm is 101
  chassis_imc_ip_pool_moid = module.imm_pool_mod.ip_pool_chassis_moid 
  # Chassis requires In-Band IP's Only  (ie must be a VLAN trunked to FI's)
  # Need chassis_imc_access_password from TFCB Workspace Variable

# =============================================================================
# NTP, DNS and SNMP Settings
# -----------------------------------------------------------------------------

  # ntp_servers   = ["ca.pool.ntp.org"]
  # ntp_servers   = ["198.18.128.1"]   #dcloud
  ntp_servers   = ["10.101.128.15"]  #richfield
  ntp_timezone  = "America/New_York"

  dns_preferred = "198.18.133.1"
  #dns_preferred = "8.8.8.8"
  #dns_alternate = "8.8.4.4"

  snmp_ip       = "10.10.10.10"
  snmp_password = var.snmp_password

# The Pools for the Pod must be created before this domain fabric module executes
depends_on = [
    module.imm_pool_mod, module.imm_pod_qos_mod
]

}
