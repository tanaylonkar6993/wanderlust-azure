variable "location" {
  description = "Azure region where resources will be provisioned. vCPU quotas are per-region/per-family, so if you hit ErrCode_InsufficientVCPUQuota or SkuNotAvailable, try another region here (and re-check `vm_size`/`node_vm_size`/`kubernetes_version` for that region - allowed SKUs and versions vary by region too)."
  default     = "West US 2"
}

variable "resource_group_name" {
  description = "Name of the resource group holding the Jenkins VM and AKS cluster"
  default     = "wanderlust-rg"
}

variable "vm_size" {
  description = "Size of the Jenkins master VM. Must be a SKU allowed for your subscription in the target region - check with `az vm list-skus --location <region> --size Standard_D2 --output table`."
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "Admin username for the Jenkins master VM"
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key used to log in to the Jenkins master VM. Must be an RSA key - Azure's admin_ssh_key does not accept ed25519."
  default     = "~/.ssh/wanderlust_azure.pub"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  default     = "wanderlust"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster. Must be a version currently supported under the standard (non-LTS) support plan in the target region - check with `az aks get-versions --location <region>`."
  default     = "1.35"
}

variable "node_count" {
  description = "Number of nodes in the AKS default node pool. Kept at 1 by default since VM(2 vCPU) + node(2 vCPU) = 4 fits a typical trial subscription's default regional vCPU quota - bump this once you've confirmed/increased your quota (see `az vm list-usage --location <region>`)."
  default     = 1
}

variable "node_vm_size" {
  description = "VM size for the AKS default node pool. AKS maintains its own supported-size list per region (narrower than the general Microsoft.Compute list) - if you hit VMSizeNotSupported, the error response lists what's valid for your region."
  default     = "Standard_D2s_v3"
}
