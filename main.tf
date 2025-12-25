module "web_app" {
  source   = "./modules/web-app"
  app_name = "web-app"
  replicas = 2
}

module "database" {
  source = "./modules/database"
}

module "monitoring" {
  source = "./modules/monitoring"
}

resource "kubernetes_ingress_v1" "web_app" {
  metadata {
    name = "web-app-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "web-app"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "web_app" {
  metadata {
    name = "web-app-hpa"
  }
  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = "web-app"
      api_version = "apps/v1"
    }
    min_replicas = 2
    max_replicas = 5
    target_cpu_utilization_percentage = 50
  }
}
