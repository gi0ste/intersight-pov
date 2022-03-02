variable user_name {
    type = string
    description = "The O.Cloud username"
}

variable tenant_name {
    type = string
    description = "The O.Cloud tenant name"
}

variable tenant_id {
    type = string
    description = "The O.Cloud tenant ID"
}

variable password {
    type = string
    description = "The O.Cloud password for the given username"
}

variable auth_url {
    type = string
    description = "The O.Cloud authentication URL "
}

variable region {
    type = string
    description = "The O.Cloud default region"
}

variable ssh_key {
    type = string
    sensitive = true
    description = "The SSH Private key use to access the VMs"
}

variable network_name {
  type = string
  description = "The O.Cloud network"
}

variable keypair_name {
  type = string
  description = "The keypair in O.Cloud to use for the VM. This must exist in O.Cloud and it must match the provided ssh_key"
}