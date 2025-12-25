resource "kubernetes_stateful_set" "mysql" {
  metadata {
    name = "mysql"
  }
  spec {
    replicas = 1
    service_name = "mysql"
    selector {
      match_labels = { app = "mysql" }
    }
    template {
      metadata {
        labels = { app = "mysql" }
      }
      spec {
        container {
          name  = "mysql"
          image = "mysql:8.0"
          port {
            container_port = 3306
          }
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "rootpass123"
          }
          volume_mount {
            name       = "mysql-storage"
            mount_path = "/var/lib/mysql"
          }
          resources {
            requests = { memory = "256Mi", cpu = "100m" }
            limits   = { memory = "512Mi", cpu = "200m" }
          }
        }
      }
    }
    volume_claim_template {
      metadata {
        name = "mysql-storage"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = { storage = "1Gi" }
        }
        # ⬇️ Pas de volumeName → utilisation du StorageClass par défaut
      }
    }
  }
}

resource "kubernetes_service" "mysql" {
  metadata {
    name = "mysql"
  }
  spec {
    selector = { app = "mysql" }
    port {
      port = 3306
    }
  }
}
