# Configuration de variables d'environnement pour l'éxécution #
###############################################################
locals {
  hosts = {
    "grafana"  = "grafana.arig.local"
    "influxdb" = "influxdb.arig.local"
    "postgres" = "localhost"
  }

  users = {
    "admin_username"    = "admin"
    "admin_password"    = "admin"
    "arig_username"     = "arig"
    "arig_password"     = "arig"
    "postgres_username" = "postgres"
    "postgres_password" = "postgres"
    "root_username"     = "root"
    "root_password"     = "root"
  }

  bddName = "robots"
}
