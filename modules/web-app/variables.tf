variable "app_name" {
  description = "Nom de l'application"
  type        = string
}

variable "replicas" {
  description = "Nombre de replicas"
  type        = number
  default     = 2
}

variable "image" {
  description = "Image conteneur"
  type        = string
  default     = "nginx:latest"
}

variable "port" {
  description = "Port applicatif"
  type        = number
  default     = 80
}
