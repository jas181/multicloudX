resource "google_service_account" "nodes" {
  project      = var.project_id
  account_id   = "gke-${var.name_prefix}"
  display_name = "MultiCloudX GKE node identity"
}

resource "google_project_iam_member" "nodes_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.nodes.email}"
}

resource "google_project_iam_member" "nodes_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.nodes.email}"
}

resource "google_container_cluster" "this" {
  name                     = "gke-${var.name_prefix}"
  project                  = var.project_id
  location                 = var.region
  network                  = var.network_id
  subnetwork               = var.subnet_id
  remove_default_node_pool = true
  initial_node_count       = 1
  networking_mode          = "VPC_NATIVE"
  resource_labels          = var.labels
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
  ip_allocation_policy {}
  release_channel { channel = "REGULAR" }
}

resource "google_container_node_pool" "system" {
  name       = "system"
  project    = var.project_id
  location   = var.region
  cluster    = google_container_cluster.this.name
  node_count = 2
  autoscaling {
    min_node_count = 2
    max_node_count = 4
  }
  node_config {
    machine_type    = "e2-standard-2"
    service_account = google_service_account.nodes.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    labels          = { workload = "system" }
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  depends_on = [google_project_iam_member.nodes_logging, google_project_iam_member.nodes_monitoring]
}
