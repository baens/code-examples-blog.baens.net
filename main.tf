provider "google" {
  version = "2.9.1"
  project = "${var.project}"
  zone    = "${var.zone}"
}

resource "google_compute_firewall" "http-traffic" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["http-traffic"]
}

resource "google_compute_firewall" "http-ssh" {
  name    = "allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh-traffic"]
}

data "template_file" "cloud-init" {
  template = "${file("cloud-init.yml.tmpl")}"

  vars = {
    registry = "${var.registry}"
    username = "${var.username}"
    password = "${var.password}"
    image    = "${var.image}"
  }
}

resource "google_compute_instance" "cos-instnace" {
  name         = "cos-instance-${substr(md5(file("cloud-init.yml.tmpl")),0,10)}"
  machine_type = "n1-standard-1"

  tags = ["http-traffic", "ssh-traffic"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-73-11647-217-0"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // this empty block creates a public IP address
    }
  }

  metadata {
    "user-data" = "${data.template_file.cloud-init.rendered}"
  }
}

output "address" {
  value = "${google_compute_instance.cos-instnace.network_interface.0.access_config.0.nat_ip}"
}
