# ConfigMap
resource "kubernetes_config_map" "app" {
  metadata {
    name = "${var.app_name}-config"
  }
  data = {
    APP_ENV = "dev"
    LOG_LEVEL = "info"
  }
}

# Secret
resource "kubernetes_secret" "app" {
  metadata {
    name = "${var.app_name}-secret"
  }
  data = {
    api_key = base64encode("dev-secret-key-123")
  }
}

# Deployment
resource "kubernetes_deployment" "app" {
  metadata {
    name = var.app_name
    labels = {
      app = var.app_name
    }
  }
  spec {
    replicas = var.replicas
    selector {
      match_labels = {
        app = var.app_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }
      spec {
        container {
          image = var.image
          name  = var.app_name
          port {
            container_port = var.port
          }
          env_from {
            config_map_ref {
              name = kubernetes_config_map.app.metadata[0].name
            }
          }
          env {
            name = "API_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.app.metadata[0].name
                key  = "api_key"
              }
            }
          }
        }
      }
    }
  }
}

# Service
resource "kubernetes_service" "app" {
  metadata {
    name = var.app_name
  }
  spec {
    selector = {
      app = kubernetes_deployment.app.metadata[0].labels.app
    }
    port {
      port        = var.port
      target_port = var.port
    }
    type = "NodePort"
  }
}
