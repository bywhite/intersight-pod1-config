# Create a sequential IP pool for IMC access. Change the from and size to what you would like
# Mac tip: Use CMD+K +C to comment out blocks.   CMD+K +U will un-comment blocks of code

module "imm_pool_mod" {
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods//imm-pod-pools-mod"
  
  # external sources
  organization    = local.org_moid

  # every policy created will have this prefix in its name
  policy_prefix = local.pod_policy_prefix
  description   = local.description

  ip_size     = "18"
  ip_start = "192.168.21.100"
  ip_gateway  = "192.168.21.1"
  ip_netmask  = "255.255.255.0"
  ip_primary_dns = "192.168.60.7"

  chassis_ip_size     = "4"
  chassis_ip_start = "192.168.21.118"
  chassis_ip_gateway  = "192.168.21.1"
  chassis_ip_netmask  = "255.255.255.0"
  chassis_ip_primary_dns = "192.168.60.7"

  pod_id = local.pod_id
  # used to create moids for Pools: MAC, WWNN, WWPN

  tags = [
    { "key" : "Environment", "value" : "dev" },
    { "key" : "Orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "ofl-dev-pod1" }
  ]
}


