provider "google" {
  project = var.project   # Use variable for project
  region  = var.region    # Use variable for region
  zone    = var.zone      # Use variable for zone
}

# Create network
resource "google_compute_network" "default" {
  name                    = "windows-vm-network"
  auto_create_subnetworks  = true
}

# Create firewall rule to allow traffic
resource "google_compute_firewall" "allow-traffic" {
  name    = "allow-traffic"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "3389"]  # HTTP, HTTPS, and RDP
  }

  # Allow from all IP addresses (0.0.0.0/0)
  source_ranges = ["0.0.0.0/0"]
}

# Reserve external IP address
resource "google_compute_address" "windows-vm-ip" {
  name = "windows-vm-ip"
}

resource "google_compute_instance" "windows-vm" {
  name         = "windows-server-2019-vm"
  machine_type = "e2-highmem-2"  # 2 vCPU, 16 GB memory
  zone         = var.zone

  allow_stopping_for_update = true  # Allow stopping for update

  boot_disk {
    initialize_params {
      image        = var.image  # Use variable for image
      size         = 50  # Disk size in GB
      type         = "pd-standard"  # Standard persistent disk
    }
  }

   network_interface {
    network = "default"
    access_config {}
  }

  service_account {
    email  = "default"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]  # Default access
  }

  metadata = {
    enable-oslogin = "false"  # Disable OS login to allow username/password authentication
  }

  tags = ["http-server", "https-server", "rdp-server"]  # Allow tags for firewall rules
}



# Generate Windows password using gcloud command
resource "null_resource" "windows_password" {
  provisioner "local-exec" {
    command = "/home/khaleel/google-cloud-sdk/bin/gcloud compute reset-windows-password windows-server-2019-vm --zone=${var.zone} --user=${var.username}"
  }

  # Ensure this resource is triggered after the instance is created
  depends_on = [google_compute_instance.windows-vm]
}

# Outputs for VM information
output "external_ip" {
  value = google_compute_address.windows-vm-ip.address
}

output "username" {
  value = "you know your username"  # Replace with the actual admin user if different
}

output "password" {
  value = "Run 'gcloud compute reset-windows-password' manually for security reasons"  # Security note for password
}

# Generate RDP file for remote access
resource "local_file" "rdp_file" {
  content = <<EOT
    full address:s:${google_compute_address.windows-vm-ip.address}
    username:s:${var.username}
  EOT
  filename = "${path.module}/windows-server-2019-vm.rdp"
}

# # Variable for the zone
# variable "zone" {
#   default = "us-central1-a"  # Specify default zone
# }
