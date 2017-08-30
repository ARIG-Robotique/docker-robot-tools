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

# Configuration des providers #
###############################

provider "grafana" {
  version = "~> 0.1"

  url = "http://${var.hosts["grafana"]}/"
  auth = "${var.users["admin_username"]}:${var.users["admin_password"]}"
}

provider "influxdb" {
  version = "~> 0.1"

  url = "http://${var.hosts["influxdb"]}/"
  username = "${var.users["root_username"]}"
  password = "${var.users["root_password"]}"
}

provider "postgresql" {
  version = "~> 0.1"

  host = "${var.hosts["postgres"]}"
  username = "${var.users["postgres_username"]}"
  password = "${var.users["postgres_password"]}"
  sslmode = "disable"
}

# Configuration PostgreSQL #
############################
resource "postgresql_role" "arig" {
  name = "${var.users["arig_username"]}"
  password = "${var.users["arig_password"]}"
  login = true
}

resource "postgresql_database" "robots" {
  name = "${var.bddName}"
  owner = "${postgresql_role.arig.name}"
  allow_connections = true
}

# Configuration Influx DB #
###########################
resource "influxdb_database" "robots" {
  name = "${var.bddName}"
}

resource "influxdb_user" "arig" {
  name = "${var.users["arig_username"]}"
  password = "${var.users["arig_password"]}"

  grant {
    database = "${influxdb_database.robots.name}"
    privilege = "ALL"
  }
}

# Configuration Grafana #
#########################
resource "grafana_data_source" "influxdb_robots" {
  type = "influxdb"
  name = "influxdb-robots"
  url = "http://influxdb:8086/"
  username = "${influxdb_user.arig.name}"
  password = "${influxdb_user.arig.password}"
  database_name = "${influxdb_database.robots.name}"
  is_default = true
  access_mode = "proxy"
}

resource "grafana_dashboard" "robots" {
  config_json = "${file("dashboards/grafana-robots.json")}"
}
