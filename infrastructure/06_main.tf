# Configuration PostgreSQL #
############################
resource "postgresql_role" "arig" {
  name = "${local.users["arig_username"]}"
  password = "${local.users["arig_password"]}"
  login = true
}

resource "postgresql_database" "robots" {
  name = "${local.bddName}"
  owner = "${postgresql_role.arig.name}"
  allow_connections = true
}

# Configuration Influx DB #
###########################
resource "influxdb_database" "robots" {
  name = "${local.bddName}"
}

resource "influxdb_user" "arig" {
  name = "${local.users["arig_username"]}"
  password = "${local.users["arig_password"]}"

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

resource "grafana_data_source" "pg_robots" {
  type = "postgres"
  name = "pg-robots"
  url = "pg:5432"
  username = "${postgresql_role.arig.name}"
  password = "${postgresql_role.arig.password}"
  database_name = "${postgresql_database.robots.name}"
  is_default = false
  access_mode = "proxy"
}

resource "grafana_dashboard" "asserv_propulsions" {
  config_json = "${file("dashboards/grafana-asserv-propulsions.json")}"
}

resource "grafana_dashboard" "tasks" {
  config_json = "${file("dashboards/grafana-tasks.json")}"
}

resource "grafana_dashboard" "logs" {
  config_json = "${file("dashboards/grafana-logs.json")}"
}

resource "grafana_dashboard" "match" {
  config_json = "${file("dashboards/grafana-match.json")}"
}