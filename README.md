
# Creating servers in Intersight using Terraform Cloud for Business

This terraform plan for Intersight can create multiple IMM domains.

To keep the code simple and compact, it references an Intersight policy bundle here:
https://github.com/bywhite/cen-iac-imm-dev-pod1-mods
based initially from Patrick's module:  https://github.com/pl247/tf-intersight-policy-bundle

The pod-pools are created based on the Pod ID and can be varied in pool size. Pools are created first (depends_on)
The pod-domains create the policies and profiles needed for both FI's and chassis
The pod-srv-templates create a specified number server profiles based on a common server template

All that is required to create a new domain is to copy pod-domain-vmw-1.tf to a new file name and change 3 identifiers at the top of the pod-domain-<new_name> module.  
    Example: replace instances of "vmw_1" with <new_name> "vmw_2"
        intersight_policy_bundle_vmw_1     with    intersight_policy_bundle_vmw_2        (module name)
        ofl-dev-pod1-vmw1                  with    ofl-dev-pod1-vmw2                     (policy prefix)
        ofl-dev-pod1-vmw1                  with    ofl-dev-pod1-vmw2                     (tag value)

Next Steps are to create the Server Profile Templates and Profiles as needed
Lastly as equipment becomes available, associate profiles with physical equipment


### Directions

1. Create a workspace in TFCB to match same in main.tf

2. Edit the name of the backend organization variable in the main.tf to match that of your TFCB organization (the name of the grouping that holds all of your workspaces)

3. Add the following variables in your workspace:
    - api_key = the API Key ID you create in Intersight using version 2
    - secretkey (make sensitive) = the secretkey of your Intersight API key
    - endpoint = https://intersight.com    (a private appliance would have its own DNS name)

### Note about Terraform destroy

When attempting a `terraform destroy`, Terraform is unable to remove the policies that are in use (IE: by the domain profile). To get around this, you will have to delete the domain profile manually first and possibly any server profiles that are using any of the profiles or policies created.
You may need to run the destroy more than once to ensure you get everything.
