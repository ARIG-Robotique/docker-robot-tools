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

# Configuration Grafana #
#########################
resource "grafana_data_source" "influxdb_robots" {
  type          = "influxdb"
  name          = "influxdb-robots"
  url           = "http://influxdb.arig.org:8086/"
  username      = local.users["arig_username"]
  password      = local.users["arig_password"]
  database_name = local.bddName
  is_default    = true
  access_mode   = "proxy"
}

resource "grafana_data_source" "pg_robots" {
  type          = "postgres"
  name          = "pg-robots"
  url           = "pg.arig.org:5432"
  username      = postgresql_role.arig.name
  password      = postgresql_role.arig.password
  database_name = postgresql_database.robots.name
  is_default    = false
  access_mode   = "proxy"
}

resource "grafana_folder" "robots" {
  title = "Robots"
}

resource "grafana_dashboard" "robot_asserv_propulsions" {
  config_json = file("dashboards/grafana-robot-asserv-propulsions.json")
  folder      = grafana_folder.robots.id
}

resource "grafana_dashboard" "robot_tasks" {
  config_json = file("dashboards/grafana-robot-tasks.json")
  folder      = grafana_folder.robots.id
}

resource "grafana_dashboard" "robot_match" {
  config_json = file("dashboards/grafana-robot-match.json")
  folder      = grafana_folder.robots.id
}
