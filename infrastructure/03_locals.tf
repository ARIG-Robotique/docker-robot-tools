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
    arig_password     = "arig"
    postgres_username = "postgres"
    postgres_password = "postgres"
    influxdb_auth_token = "super-token-connu-pour-auth"
  }

  bddName = "robots"
}
