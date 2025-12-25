resource "kubernetes_daemonset" "fluentd" {
  metadata {
    name = "fluentd"
  }
  spec {
    selector {
      match_labels = { app = "fluentd" }
    }
    template {
      metadata {
        labels = { app = "fluentd" }
      }
      spec {
        toleration {
          key      = "node-role.kubernetes.io/control-plane"
          operator = "Exists"
          effect   = "NoSchedule"
        }
        container {
          name  = "fluentd"
          image = "fluent/fluentd:v1.14-1"
          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
          }
        }
        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }
      }
    }
  }
}
