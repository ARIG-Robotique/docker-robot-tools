# Configuration PostgreSQL #
############################
resource "postgresql_role" "arig" {
  name     = local.users["arig_username"]
  password = local.users["arig_password"]
  login    = true
}

resource "postgresql_database" "robots" {
  name              = local.bddName
  owner             = postgresql_role.arig.name
  allow_connections = true
}

# Configuration Influx DB #
###########################
resource "influxdb_database" "robots" {
  name = local.bddName
}

resource "influxdb_user" "arig" {
  name     = local.users["arig_username"]
  password = local.users["arig_password"]

  grant {
    database  = influxdb_database.robots.name
    privilege = "ALL"
  }
}

# Configuration Grafana #
#########################
resource "grafana_data_source" "influxdb_robots" {
  type          = "influxdb"
  name          = "influxdb-robots"
  url           = "http://influxdb:8086/"
  username      = influxdb_user.arig.name
  password      = influxdb_user.arig.password
  database_name = influxdb_database.robots.name
  is_default    = true
  access_mode   = "proxy"
}

resource "grafana_data_source" "pg_robots" {
  type          = "postgres"
  name          = "pg-robots"
  url           = "pg:5432"
  username      = postgresql_role.arig.name
  password      = postgresql_role.arig.password
  database_name = postgresql_database.robots.name
  is_default    = false
  access_mode   = "proxy"
}

resource "grafana_data_source" "loki_robots" {
  type        = "loki"
  name        = "loki-robots"
  url         = "loki:3100"
  is_default  = false
  access_mode = "proxy"
}

resource "grafana_folder" "infra" {
  title = "Infrastructure"
}

resource "grafana_folder" "robots" {
  title = "Robots"
}

resource "grafana_dashboard" "infra_logs" {
  config_json = file("dashboards/grafana-infra-logs.json")
  folder      = grafana_folder.infra.id
}

resource "grafana_dashboard" "robot_asserv_propulsions" {
  config_json = file("dashboards/grafana-robot-asserv-propulsions.json")
  folder      = grafana_folder.robots.id
}

resource "grafana_dashboard" "robot_tasks" {
  config_json = file("dashboards/grafana-robot-tasks.json")
  folder      = grafana_folder.robots.id
}

resource "grafana_dashboard" "robot_logs" {
  config_json = file("dashboards/grafana-robot-logs.json")
  folder      = grafana_folder.robots.id
}

resource "grafana_dashboard" "robot_match" {
  config_json = file("dashboards/grafana-robot-match.json")
  folder      = grafana_folder.robots.id
}
