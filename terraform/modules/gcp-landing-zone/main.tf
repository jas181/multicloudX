resource "google_storage_bucket" "logs" {
  name                        = "${var.name_prefix}-logs-${var.project_id}"
  project                     = var.project_id
  location                    = var.location
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  labels                      = var.labels
  versioning { enabled = true }
}

resource "google_logging_project_sink" "security" {
  name                   = "multicloudx-security-${var.name_prefix}"
  project                = var.project_id
  destination            = "storage.googleapis.com/${google_storage_bucket.logs.name}"
  filter                 = "logName:(cloudaudit.googleapis.com)"
  unique_writer_identity = true
}

resource "google_storage_bucket_iam_member" "sink_writer" {
  bucket = google_storage_bucket.logs.name
  role   = "roles/storage.objectCreator"
  member = google_logging_project_sink.security.writer_identity
}
