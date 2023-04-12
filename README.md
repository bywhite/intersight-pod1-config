# Intersight Infrastructure-as-Code for Enterprise Operations - Demo


# Creating Policies and Profiles in Intersight using Terraform Cloud for Business
    (If you wish to set up Terraform on your local workstation - see bottom section)

# This terraform plan for Intersight can create multiple Intersight Managed UCS Domains.
The domains are provisioned within a POD based physical architecture akin to an AWS VPC.

This module supports tagging with github
-  git tag -a v1.1.0 -m "Intersight IaC Enterprise Ops v1.1.0"
-  git push origin --tags
- within Module code, versioning can be specified for smoother transitioning to updated modules:
    source = "github.com/bywhite/intersight-pod1-modules//imm-domain-fabric-6536-mod?ref=v1.1.0"


To keep the code simple and compact, it references an Intersight policy bundle here:
https://github.com/bywhite/intersight-pod1-modules//

The pod-pools are created based on the Pod ID and can be varied in pool size. Pools are created first (depends_on)
The pod-domains create the policies and profiles needed for both FI's and Chassis
The pod-srv-template creates a server profile template. Server profile derivation is out of scope of this plan.

All that is required to create a new domain is to copy pod-domain-1.tf to a new file name and change 3 identifiers in the file: 
    Example:
        intersight_pod1_domain_1           with    intersight_pod1_vmw2              (module name)
        ofl-dev-pod1-domain-1              with    ofl-dev-pod1-vmw2                 (policy prefix)
        ofl-dev-pod1-domain-1              with    ofl-dev-pod1-vmw2                 (tag value)

Next Steps are to create the Server Profile Templates as needed for the Pod.
Lastly as equipment becomes available, associate profiles with physical equipment


### Directions for TFCB

1. Create a workspace in TFCB to match same in main.tf

2. Edit the name of the backend organization variable in the main.tf to match that of your TFCB organization (the name of the grouping that holds all of your workspaces)

3. Add the following variables in your workspace:
    - api_key = the API Key ID you create in Intersight using version 2
    - secretkey (make sensitive) = the secretkey of your Intersight API key
    - endpoint = https://intersight.com    (a private appliance would have its own DNS name)
    - imc_admin_password = your choice of passwords for accessing IMC on servers with admin account
    - snmp_password      = your choice to match snmp monitoring environment
    = organization       = your "pre-defined" organization in Intersight where objects will be created

### Note about Terraform destroy

When attempting a `terraform destroy`, Terraform is unable to remove the policies that are in use (IE: by the domain profile). To get around this, you will have to delete the domain profile manually first and possibly any server profiles that are using any of the profiles or policies created.
You may need to run the destroy more than once to ensure you get everything.

### Note about Code Repository
It is recommended that you create your own repositories for your experimentation.
Although versioning is used for the github repo, there is no guarantee from day-to-day whether this demo repo will exist or not.



==========================================================================
 ================  Local Workstation Setup for Terraform ================
==========================================================================


## Getting Started on your workstation (Mac)

## Install Visual Studio Code

- Download Here: [Visual Studio Code](https://code.visualstudio.com/Download)

- Recommended Extensions: 
  - GitHub Pull Requests and Issues - Author GitHub
  - HashiCorp Terraform - Author HashiCorp


## Install git

- Linux - Use the System Package Manager - apt/yum etc.

```bash
sudo apt update
sudo apt install git
```

- Windows Download Here: [Git](https://git-scm.com/download/win)

configure Git Credentials

```bash
git config --global user.name "<username>"   
git config --global user.email "<email>"
```

- Authorize Visual Studio Code to GitHub via the GitHub Extension


## Terraform Requirements

The plan uses features introduced in 0.14 of Terraform.  So we need 0.14 or preferrably >1.0

- Download Here [terraform](https://www.terraform.io/downloads.html) 
- For Windows Make sure it is in a Directory that is in the system path.

### Terraform Modules and Providers

The plan uses the Intersight Terraform Provider.
- [Intersight Provider](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest)


## Running the Terraform Code without TFCB

- It is recommend to add the following secure variables to your environment before running the script


- Linux

```bash
## Intersight Variables
export TF_VAR_apikey="<your_intersight_api_key>"
export TF_VAR_secretkey=`cat ~/Downloads/SecretKey.txt` 
# The above example is based on the key being in your Downloads folder.  Correct for your environment.

## Terraform Cloud Variables (if using TFCB as back end)
export TF_VAR_terraform_cloud_token="<your_terraform_cloud_token>"
```

- Windows - Plugin your API Keys and the File Location of the Intersight Secret Key.

```powershell
## Powershell Intersight Variables
$env:TF_VAR_apikey="<your_intersight_api_key>"
$env:TF_VAR_secretkey="$HOME\Downloads\SecretKey.txt"
# The above example is based on the key being in your Downloads folder.  Correct for your environment.

## Powershell Terraform Cloud Variables
$env:TF_VAR_terraform_cloud_token="<your_terraform_cloud_token>"
```


## Terraform Plan and Apply using TFCB backend
 If separating code into multiple workspaces, at is important to execute the Workspaces in the following Order:

1. pools
2. domain profiles
3. policies
4. profiles


## Disclaimer

This code is provided as is.  No warranty, support, or guarantee is provided with this.

## Synopsis

The goal of this code is to begin to familiarize you with Terraform Provider for Intersight 


## Contents

- Terraform config files that call modules with attributes to create Intersight resources.
- Terraform modules to provide consistency and ease of use for defining Intersight resources.


### Use Cases

- Create UCS Domain infrastructure profiles and policies
- Create UCS Chassis profiles and policies
- Create Server Template profiles and policies

### Code Documentation

Documentation for the code is inline with the code in addition to the README.md files.
