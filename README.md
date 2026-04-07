# Automatisation in Proxmox

Heelo! It's my project fot virtualization in Proxmox using Packer, Terraform and Ansible.

---

## What is it do

* **Packer**: From Ubuntu 24.04 Server ISO make template VM with Cloud-Init.
* **Terraform**: Creating VM's with hostname, SSH, IP.
* **Ansible**: configure K3S cluster, master and worker nodes.

---

## How to use

### 1️⃣ Packer

```bash
cd packer
packer init .
packer build -var-file="secret.pkrvars.hcl" .
```


### 2️⃣ Terraform

```bash
cd ../
cd terraform
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

### 3️⃣ Ansible

```bash
cd ../
cd ansible
ansible-playbook -i inventory k3s.yml
```

---

## Project structure

```
.
├── packer/      # Packer templates, vars, files
├── terraform/   # Terraform main.tf, variables.tf, outputs.tf, tfvars
├── ansible/     # Playbooks, roles, inventory
├── .gitignore   # ;)
└── README.md    # :D
```
## Trouble shouting

### Terraform proxmox telmate provider

There may be issue when Terraform asking for "VM.Monitor" permission.
In Proxmox 9 it doesn't exists anymore, but was in Proxmox 8.

To fix it you need manually install at least `3.0.2-rc07` version of telmate/proxmox provider. 

*1*. Download .zip file with command
```sh
wget https://github.com/Telmate/terraform-provider-proxmox/releases/download/v3.0.2-rc07/terraform-provider-proxmox_3.0.2-rc07_linux_amd64.zip
```

*2.* Create directory
```sh
mkdir -p .terraform/providers/registry.terraform.io/telmate/proxmox/3.0.2-rc07/linux_amd64/
```
*3.* Unzip it and move 
```sh
unzip terraform-provider-proxmox_3.0.2-rc07_linux_amd64.zip

mv terraform-provider-proxmox_v3.0.2-rc07 .terraform/providers/registry.terraform.io/telmate/proxmox/3.0.2/linux_amd64/terraform-provider-proxmox_v3.0.2-rc07
mv LICENSE .terraform/providers/registry.terraform.io/telmate/proxmox/3.0.2/linux_amd64/LICENSE
mv README.md .terraform/providers/registry.terraform.io/telmate/proxmox/3.0.2/linux_amd64/README.md

chmod +x .terraform/providers/registry.terraform.io/telmate/proxmox/3.0.2/linux_amd64/terraform-provider-proxmox_v3.0.2-rc07
```

*4.* Change `main.tf` file's header to:

```tf
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }

    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }
  }
}
```

*5.* Run `terrafrom init` again, older version, for example 2.9 you can delete by command
```sh
rm -rf .terraform/providers/registry.terraform.io/telmate/proxmox/2.9*
```