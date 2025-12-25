resource "kubernetes_horizontal_pod_autoscaler_v1" "web_app" {
  metadata {
    name = "web-app-hpa"
  }
  spec {
    scale_target_ref {
      kind = "Deployment"
      name = "web-app"
    }
    min_replicas = 2
    max_replicas = 5
    target_cpu_utilization_percentage = 50
  }
}
