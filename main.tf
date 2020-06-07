provider "google" {
  project = "baens-scratchpad"
  region  = "us-west3"
}

data "google_client_config" "default" {
}

provider "kubernetes" {
  load_config_file = false
  host             = "https://${google_container_cluster.primary.endpoint}"
  token            = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  )
}

resource "kubernetes_namespace" "test" {
  metadata {
    name = "test"
  }

  depends_on = [google_container_node_pool.primary]
}


resource "random_password" "user" {
  length = 16
}

resource "google_sql_user" "users" {
  name     = "user"
  instance = google_sql_database_instance.instance.name
  password = random_password.user.result
}

resource "kubernetes_secret" "user" {
  metadata {
    name      = "user-password"
    namespace = kubernetes_namespace.test.metadata[0].name
  }

  data = {
    password = random_password.user.result
  }
}
