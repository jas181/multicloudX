output "instance_group_id" { value = google_compute_region_instance_group_manager.app.instance_group }
output "internal_load_balancer_ip" { value = google_compute_forwarding_rule.app.ip_address }
