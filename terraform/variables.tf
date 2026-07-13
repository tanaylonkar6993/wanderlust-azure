variable "location" {
  description = "Azure region where resources will be provisioned"
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the resource group holding the Jenkins VM and AKS cluster"
  default     = "wanderlust-rg"
}

variable "vm_size" {
  description = "Size of the Jenkins master VM"
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "Admin username for the Jenkins master VM"
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key used to log in to the Jenkins master VM"
  default     = "~/.ssh/id_rsa.pub"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  default     = "wanderlust"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster"
  default     = "1.30"
}

variable "node_count" {
  description = "Number of nodes in the AKS default node pool"
  default     = 2
}

variable "node_vm_size" {
  description = "VM size for the AKS default node pool"
  default     = "Standard_D2s_v3"
}
