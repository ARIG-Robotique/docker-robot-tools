# Data source InfluxDB
resource "grafana_data_source" "influxdb_robots" {
  type          = "influxdb"
  name          = "influxdb-robots"
  url           = "http://${local.hosts.influxdb}:8086/"
  is_default    = true
  
  database_name = local.bddName
  basic_auth_enabled = true
  basic_auth_username = local.users.arig_username
  json_data_encoded = jsonencode({
    authType = "default"
    basicAuthPassword = local.users.arig_password
  })
}

# Data source PostgreSQL
resource "grafana_data_source" "pg_robots" {
  type          = "postgres"
  name          = "pg-robots"
  url           = "${local.hosts.postgres}:5432"
  
  database_name = postgresql_database.robots.name
  username      = postgresql_role.arig.name
  secure_json_data_encoded = jsonencode({
    password      = postgresql_role.arig.password
  })
}

# Dashboards
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
