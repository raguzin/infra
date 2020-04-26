output "app_external_ip" {
  value = google_compute_instance.app.*.network_interface.0.access_config.0.nat_ip
}

# show external ip address of load balancer
output "load-balancer-ip-address" {
  value = google_compute_forwarding_rule.forwarding_rule.ip_address
}