# БАЛАНСИРОВЩИК

resource "google_compute_forwarding_rule" "forwarding_rule" {
  name = "puma-forwarding-rule"
  target = google_compute_target_pool.target_pool.self_link
  port_range = "9292"
}

# "europe-west1-d/reddit-app",
resource "google_compute_target_pool" "target_pool" {
  name          = "puma-target-pool"
  instances = [
      "europe-west1-d/reddit-app",
  ]
  health_checks = [google_compute_http_health_check.health_check.self_link]
}

resource "google_compute_http_health_check" "health_check" {
  name               = "puma-health-check"
  check_interval_sec = 1
  timeout_sec        = 1
  port = "9292"
}

# show external ip address of load balancer
output "load-balancer-ip-address" {
  value = google_compute_forwarding_rule.forwarding_rule.ip_address
}