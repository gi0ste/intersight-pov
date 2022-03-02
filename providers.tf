terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.44.0"
    }

    rke = {
      source = "rancher/rke"
      version = "1.2.4"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.3.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.6.1"
    }

    grafana = {
      source = "grafana/grafana"
      version = "1.14.0"
    }
  }
}

# OpenStack provider configuration
provider "openstack" {
  user_name   = var.user_name
  tenant_name = var.tenant_name
  password    = var.password
  auth_url    = var.auth_url
  region      = var.region
}

# Kubernetes provider
provider "kubernetes" {
  host = rke_cluster.obs_k8s_cluster.api_server_url
  client_certificate = rke_cluster.obs_k8s_cluster.client_cert
  client_key = rke_cluster.obs_k8s_cluster.client_key
  cluster_ca_certificate = rke_cluster.obs_k8s_cluster.ca_crt
}

# Helm provider configuration
provider "helm" {
  kubernetes {
    host = rke_cluster.obs_k8s_cluster.api_server_url
    client_certificate = rke_cluster.obs_k8s_cluster.client_cert
    client_key = rke_cluster.obs_k8s_cluster.client_key
    cluster_ca_certificate = rke_cluster.obs_k8s_cluster.ca_crt
  }
}


provider "grafana" {
  url  = "https://grafana.${openstack_compute_instance_v2.obs_vm.access_ip_v4}.nip.io"
  auth = format("%s:%s", "admin", lookup(data.kubernetes_secret.obs_grafana_secret.data, "admin-password", "not_found"))
  insecure_skip_verify = true
}