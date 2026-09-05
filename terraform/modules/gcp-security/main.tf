resource "google_project_service" "security_command_center" {
  project            = var.project_id
  service            = "securitycenter.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloud_asset_inventory" {
  project            = var.project_id
  service            = "cloudasset.googleapis.com"
  disable_on_destroy = false
}
