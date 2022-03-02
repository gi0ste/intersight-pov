# k8s output values
output "k8s_kubeconfig" {
  sensitive = true
  description = "The admin kubeconfig for the cluster"
  value = rke_cluster.obs_k8s_cluster.kube_config_yaml
}

# charts output values
output "grafana_url" {
  description = "Grafana access URL"
  value = "https://grafana.${openstack_networking_floatingip_v2.public_ip.address}.nip.io"
}

output "grafana_initial_admin_pass" {
  sensitive = true
  description = "Grafana initial admin password"
  value = lookup(data.kubernetes_secret.obs_grafana_secret.data, "admin-password", "not_found")
}

output "prometheus_url" {
  description = "Grafana access URL"
  value = "https://prometheus.${openstack_networking_floatingip_v2.public_ip.address}.nip.io"
}

output "consul_url" {
  description = "Consul access URL"
  value = "https://consul.${openstack_networking_floatingip_v2.public_ip.address}.nip.io"
}

output "observability_vm_intip" {
  description = "Observability VM internal IP"
  value = openstack_compute_instance_v2.obs_vm.access_ip_v4
}

output "client_cert" {
  sensitive = true
  description = "Client Cert"
  value = rke_cluster.obs_k8s_cluster.client_cert
}

output "k8s_url" {
  sensitive = true
  description = "K8s Cluster Url"
  value = rke_cluster.obs_k8s_cluster.api_server_url
}

output "client_key" {
  sensitive = true
  description = "client key"
  value = rke_cluster.obs_k8s_cluster.client_key
}

output "ca_crt" {
  sensitive = true
  description = "ca crt"
  value = rke_cluster.obs_k8s_cluster.ca_crt
}