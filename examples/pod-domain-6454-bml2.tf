# # =============================================================================
# # This defines the desired configuration of the ofl-dev-pod1-bml-1 IMM domain
# # 
# # Builds: Domain Cluster, Switch, and Chassis Profiles & their Policies
# #         configured for 6454 FI and 9508 chassis (May work with 5108 chassis)
# # -----------------------------------------------------------------------------


module "intersight_policy_bundle_bml_2" {
  #source = "github.com/pl247/tf-intersight-policy-bundle"
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods/imm-domain-fabric-6454-mod" #?ref=v1.2.0"

# =============================================================================
# Org external references
# -----------------------------------------------------------------------------

  # external sources
  organization    = local.org_moid

# =============================================================================
# Naming and tagging
# -----------------------------------------------------------------------------

  # every policy created will have this prefix in its name
  policy_prefix = "imm-iac-pod1-bml-2"                # <-- change when copying
  description   = "built by Terraform imm-iac-pod1-bml-1"

  #Every object created in the domain will have these tags
  tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "ofl-dev-pod1" },
    { "key" : "domain", "value" : "ofl-dev-pod1-bml2" } # <-- change when copying
  ]


# =============================================================================
# Fabric Interconnect 6545 Ethernet ports
# -----------------------------------------------------------------------------

  #FI ports to be used for ethernet port channel uplink
  port_channel_6454 = [53,54]

  # FI physical port numbers to be attached to chassis 
  server_ports_6454 = [9,10,17,18,25,26]

  # VLAN Prefix ex: vlan   >> name is: vlan-230
  vlan_prefix = "vlan"

  # Uplink VLANs Allowed List    Example: "5,6,7,8,100-130,998-1011" requires "-"
  switch_vlans_6454 = "21,60,254-255"

# =============================================================================
# Fabric Interconnect 6454 FC Ports and VSANs
# -----------------------------------------------------------------------------
    #6454 FC ports start at Port 1 up to 16 (FC on left of slider)

  # A value of 8 results in 8x 32G FC Port from ports 1 to 8
  # This sets the universal ports to FC instead of Eth
  # 6454 requires multiples of 4
  fc_port_count_6454 = 4

  #Enable or disable FC port channel creation
  create_fc_portchannel = false

  # VSAN ID for FC Uplinks
  fc_uplink_pc_vsan_id_a = 101
  fc_uplink_pc_vsan_id_b = 102

  # Aggport should be 0, when breakout not used, as with 6454
    fc_port_channel_6454 = [
    { "aggport" : 0, "port" : 1 },
    { "aggport" : 0, "port" : 2 }
  ]


# VSAN Trunking is enabled by default. One or more VSANs are required for each FI

  # Fabric A VSAN Set
  fabric_a_vsan_sets = {
    "vsan101" = {
      vsan_number   = 101
      fcoe_number   = 1101
      switch_id      = "A"
    }
  }

  # Fabric B VSAN Set
    fabric_b_vsan_sets = {
    "vsan102" = {
      vsan_number   = 102
      fcoe_number   = 1102
      switch_id      = "B"
    }
  }

# =============================================================================
# Chassis
# -----------------------------------------------------------------------------

  chassis_9508_count       = 5
  chassis_imc_access_vlan  = 21
  chassis_imc_ip_pool_moid = module.imm_pool_mod.ip_pool_chassis_moid 
  # Chassis requires In-Band IP's Only  (ie must be a VLAN trunked to FI's)
  # Need chassis_imc_access_password from TFCB Workspace Variable

# =============================================================================
# NTP, DNS and SNMP Settings
# -----------------------------------------------------------------------------

  ntp_servers   = ["ca.pool.ntp.org"]
  ntp_timezone  = "America/Chicago"

  dns_preferred = "8.8.8.8"
  dns_alternate = "8.8.4.4"

  snmp_ip       = "192.168.60.1"
  snmp_password = var.snmp_password

# The Pools for the Pod must be created before this domain fabric module executes
depends_on = [
    module.imm_pool_mod, module.imm_pod_qos_mod
]

}
