resource "google_storage_bucket" "log_bucket" {
  project = google_project.project.project_id

  name          = "sjo-lab-1-tf-output-${random_string.project-id-suffix.result}"
  force_destroy = true
}

resource "google_compute_instance" "instance" {
  project    = google_project.project.project_id
  depends_on = [google_project_service.enable_compute, google_project_service.enable_logging]

  name         = "sjo-lab-1-vm-${random_string.project-id-suffix.result}"
  zone         = "us-central1-f"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }
  network_interface {
    network = "default"

    access_config {}
  }

  service_account {
    scopes = [
      "cloud-platform"
    ]
  }

  metadata_startup_script = file("${path.module}/worker-startup-script.sh")
  metadata                = {
    lab-logs-bucket = "gs://${google_storage_bucket.log_bucket.name}/"
  }
}
