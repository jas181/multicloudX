resource "google_compute_instance_template" "app" {
  name_prefix  = "${var.name_prefix}-app-"
  project      = var.project_id
  machine_type = "e2-small"
  tags         = ["${var.name_prefix}-app"]
  labels       = var.labels
  disk {
    source_image = "projects/debian-cloud/global/images/family/debian-12"
    auto_delete  = true
    boot         = true
    disk_type    = "pd-balanced"
  }
  network_interface {
    subnetwork = var.subnet_id
  }
  metadata = { enable-oslogin = "TRUE" }
  service_account { scopes = ["https://www.googleapis.com/auth/cloud-platform"] }
}

resource "google_compute_region_instance_group_manager" "app" {
  name               = "${var.name_prefix}-app"
  project            = var.project_id
  region             = var.region
  base_instance_name = "app"
  target_size        = 2
  version { instance_template = google_compute_instance_template.app.id }
  named_port {
    name = "http"
    port = 8080
  }
  distribution_policy_zones = ["${var.region}-a", "${var.region}-b"]
  auto_healing_policies {
    health_check      = google_compute_region_health_check.app.id
    initial_delay_sec = 180
  }
}

resource "google_compute_region_autoscaler" "app" {
  name    = "${var.name_prefix}-app"
  project = var.project_id
  region  = var.region
  target  = google_compute_region_instance_group_manager.app.id
  autoscaling_policy {
    min_replicas = 2
    max_replicas = 4
    cpu_utilization { target = 0.7 }
  }
}

resource "google_compute_region_health_check" "app" {
  name    = "${var.name_prefix}-app"
  project = var.project_id
  region  = var.region
  http_health_check {
    port         = 8080
    request_path = "/health"
  }
}

resource "google_compute_region_backend_service" "app" {
  name                  = "${var.name_prefix}-app"
  project               = var.project_id
  region                = var.region
  protocol              = "HTTP"
  load_balancing_scheme = "INTERNAL"
  health_checks         = [google_compute_region_health_check.app.id]
  backend { group = google_compute_region_instance_group_manager.app.instance_group }
}

resource "google_compute_forwarding_rule" "app" {
  name                  = "${var.name_prefix}-app"
  project               = var.project_id
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.app.id
  network               = var.network_id
  subnetwork            = var.subnet_id
  ports                 = ["8080"]
}
