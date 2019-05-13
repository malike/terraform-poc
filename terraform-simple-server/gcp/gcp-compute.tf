# VARIABLES

variable "project_id" {}
variable "access_file" {}
variable "private_key_path" {}
variable "public_key_path" {}
variable "key_name" {}


# PROVIDERS
provider "google" {
    credentials = "${file("${var.access_file}")}"
    project     = "${var.project_id}"
    region      = "us-west2"
}
 
resource "random_id" "instance_id" {
  byte_length = 8
}
 
 # RESOURCES

resource "google_compute_instance" "nginx" {
    name         = "nginx-vm-${random_id.instance_id.hex}"
    machine_type = "f1-micro"
    zone         = "us-west2-a"
 
    boot_disk {
        initialize_params {
            image = "ubuntu-os-cloud/ubuntu-1604-lts"
        }
    }
 
    metadata_startup_script = "sudo apt-get -y update; sudo apt-get -y dist-upgrade ; sudo apt-get -y install nginx"
 
    network_interface {
        network = "default"
        access_config {
        }
    }
 
    metadata {
        sshKeys = "${var.key_name}:${file("${var.public_key_path}")}"
    }
}
 
resource "google_compute_firewall" "default" {
    name    = "nginx-firewall"
    network = "default"
 
    allow {
        protocol = "tcp"
        ports    = ["80","443","22"]
    }
 
    allow {
        protocol = "icmp"
    }
}
 
 # OUTPUT
output "ip" {
    value = "${google_compute_instance.nginx.network_interface.0.access_config.0.nat_ip}"
}