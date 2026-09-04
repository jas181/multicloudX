output "network_id" { value = google_compute_network.this.id }
output "app_subnet_id" { value = google_compute_subnetwork.app.id }
output "database_subnet_id" { value = google_compute_subnetwork.database.id }
