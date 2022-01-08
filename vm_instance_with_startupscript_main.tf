provider "google" {
  credentials = file("terraform-course-337515-213c0a0f0403.json")
  
  project = var.project
  region = var.region
  zone = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "new-terraform-network"
}
resource "google_compute_instance" "vm_instance" {
  name = "terraform-host"
  metadata_startup_script = file("startup.sh")
  machine_type = "f1-micro"
  tags = ["web"]
  zone = var.zone
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  target_tags = ["web"]
  source_ranges = ["0.0.0.0/0"]
}
