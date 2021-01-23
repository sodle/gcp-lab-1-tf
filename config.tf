provider "google" {
  region = "us-central1"
}

# Need a random suffix at the end because project/bucket names need to be globally unique
resource "random_string" "project-id-suffix" {
  length = 5

  lower   = true
  upper   = false
  number  = true
  special = false
}

# Billing account ID lookup by name
data "google_billing_account" "billing_account" {
  display_name = "My Trial Billing Account"
}

resource "google_project" "project" {
  name            = "Lab 1 Terraform"
  project_id      = "sjodle-lab-1-tf-${random_string.project-id-suffix.result}"
  billing_account = data.google_billing_account.billing_account.id
}

# Enable the compute and logging APIs before trying to use them
# Otherwise we get errors when creating the instance and when it tries to log
resource "google_project_service" "enable_compute" {
  project = google_project.project.project_id
  service = "compute.googleapis.com"
}

resource "google_project_service" "enable_logging" {
  project = google_project.project.project_id
  service = "logging.googleapis.com"
}
