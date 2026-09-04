resource "google_compute_network" "this" {
  name                    = "${var.name_prefix}-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "app" {
  name                     = "${var.name_prefix}-app"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.this.id
  ip_cidr_range            = "10.60.1.0/24"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "database" {
  name                     = "${var.name_prefix}-database"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.this.id
  ip_cidr_range            = "10.60.2.0/24"
  private_ip_google_access = true
}

resource "google_compute_firewall" "deny_ssh" {
  name          = "${var.name_prefix}-deny-ssh"
  project       = var.project_id
  network       = google_compute_network.this.name
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  deny {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_internal" {
  name          = "${var.name_prefix}-allow-internal"
  project       = var.project_id
  network       = google_compute_network.this.name
  direction     = "INGRESS"
  priority      = 900
  source_ranges = ["10.60.0.0/16"]
  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
}
