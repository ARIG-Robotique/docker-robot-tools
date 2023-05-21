# Configuration de variables d'environnement pour l'éxécution #
###############################################################
locals {
  hosts = {
    grafana  = "grafana.arig.org"
    postgres = "pg.arig.org"
    influxdb = "influxdb.arig.org"
  }

  users = {
    admin_username    = "admin"
    admin_password    = "admin"
    arig_username     = "arig"
    arig_password     = "arig4ever"
    postgres_username = "postgres"
    postgres_password = "postgres"
  }

  bddName = "robots"
}
