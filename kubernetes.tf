provider "random" {

}

resource "google_container_cluster" "primary" {
  name     = "primary"
  location = "us-west3"

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.network.self_link
  subnetwork = google_compute_subnetwork.subnet.self_link

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary" {
  name       = "primary"
  location   = "us-west3"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
