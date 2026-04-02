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
packer build -var-file="secret.pkrvars.hcl" ubuntu-server-noble-numbat.pkr.hcl .
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