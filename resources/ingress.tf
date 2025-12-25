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
