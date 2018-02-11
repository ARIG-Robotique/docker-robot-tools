# Configuration de variables d'environnement pour l'éxécution #
###############################################################
variable "hosts" {
  type = "map"
  description = "Variables de configuration"

  default = {
    "grafana" = "grafana.arig.local"
    "influxdb" = "influxdb.arig.local"
    "postgres" = "localhost"
  }
}

variable "users" {
  type = "map"
  description = "Configuration des utilisateur"

  default = {
    "admin_username" = "admin"
    "admin_password" = "admin"
    "arig_username" = "arig"
    "arig_password" = "arig"
    "postgres_username" = "postgres"
    "postgres_password" = "postgres"
    "root_username" = "root"
    "root_password" = "root"
  }
}

variable "bddName" {
  type = "string"
  default = "robots"
}
