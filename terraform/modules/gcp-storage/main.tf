resource "google_storage_bucket" "this" {
  name                        = "${var.name_prefix}-data-${var.project_id}"
  project                     = var.project_id
  location                    = var.location
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  labels                      = var.labels
  versioning { enabled = true }
}
