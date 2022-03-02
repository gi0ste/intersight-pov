# the observability k8s cluster
# TODO: the cloud provider configuration for block storage is compatible only with it-mil1
resource "rke_cluster" "obs_k8s_cluster" {

  authentication {
    sans = [ "${openstack_networking_floatingip_v2.public_ip.address}" ]
  }

  nodes {
    address = openstack_compute_instance_v2.obs_vm.access_ip_v4
    user = "ubuntu"
    role = ["controlplane", "worker", "etcd"]
    ssh_key = var.ssh_key
  }

  cloud_provider {
    name = "openstack"
      openstack_cloud_provider {
        global {
          auth_url  = var.auth_url
          username  = var.user_name
          password  = var.password
          tenant_name = var.tenant_name
          tenant_id = var.tenant_id
          region = var.region
        }
        block_storage {
          ignore_volume_az = true
        }
      }
  }
}

# k8s default storage class
# TODO: this storageclass configuration is compatible only with it-mil1
resource "kubernetes_storage_class" "cinder_ssd_standard" {
  metadata {
    name = "ocloud-ssd-standard"
  }
  storage_provisioner = "kubernetes.io/cinder"
  reclaim_policy = "Delete"
  parameters = {
    availability = "it-mil1"
    type = "SSD-Standard"
  }
  volume_binding_mode = "Immediate"
}

# helm release for Grafana
resource "helm_release" "obs_grafana" {
  chart = "grafana"
  name = "obs-grafana"
  repository =  "https://grafana.github.io/helm-charts"

  namespace = "observability"
  create_namespace = true

  values = [ "${templatefile("chart-values/grafana.yaml", { ingress_domain = "grafana.${openstack_networking_floatingip_v2.public_ip.address}.nip.io", internal_ingress_domain = "grafana.${openstack_compute_instance_v2.obs_vm.access_ip_v4}.nip.io"})}" ]
}

# helm release for Prometheus
resource "helm_release" "obs_prometheus" {
  chart = "prometheus"
  name = "obs-prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"

  namespace = "observability"
  create_namespace = true

  values = [ "${templatefile("chart-values/prometheus.yaml", { ingress_domain = "prometheus.${openstack_networking_floatingip_v2.public_ip.address}.nip.io" })}" ]
}

# initial Grafana admin password
data "kubernetes_secret" "obs_grafana_secret" {
  depends_on = [ helm_release.obs_grafana ]
  metadata {
    name = "obs-grafana"
    namespace = "observability"
  }
}

# helm release for Consul
resource "helm_release" "obs_consul" {
  chart = "consul"
  name = "obs-consul"
  repository =  "https://helm.releases.hashicorp.com"

  namespace = "observability"
  create_namespace = true

  values = [ "${templatefile("chart-values/consul.yaml", { ingress_domain = "consul.${openstack_networking_floatingip_v2.public_ip.address}.nip.io" })}" ]
}

resource "grafana_data_source" "prometheus" {
  depends_on = [ helm_release.obs_grafana ]
  type = "prometheus"
  name = "obs-prometheus"
  url  = "http://obs-prometheus-server"
  is_default = true

  json_data {
    http_method     = "POST"
  }
}

resource "grafana_dashboard" "metrics" {
  depends_on = [ grafana_data_source.prometheus ]
  config_json = file("dashboard/node-exporter-full_rev23.json")
}