# Data source InfluxDB
resource "grafana_data_source" "influxdb_robots" {
  type          = "influxdb"
  name          = "influxdb-robots"
  url           = "http://${local.hosts.influxdb}:8086/"
  is_default    = true
  
  json_data_encoded = jsonencode({
    dbName = local.bddName
    tlsSkipVerify = true
    httpMode = "GET"
    httpHeaderName1 = "Authorization"
  })
  secure_json_data_encoded = jsonencode({
    httpHeaderValue1 = "Token ${local.users.influxdb_auth_token}"
  })
}

resource "grafana_data_source" "influxdb_robots_flux" {
  type          = "influxdb"
  name          = "influxdb-robots-flux"
  url           = "http://${local.hosts.influxdb}:8086/"
  
  json_data_encoded = jsonencode({
      version = "Flux"
      organization = "arig"
      defaultBucket = local.bddName
      tlsSkipVerify = true
  })
  secure_json_data_encoded = jsonencode({
    token = local.users.influxdb_auth_token
  })
}

# Data source PostgreSQL
resource "grafana_data_source" "pg_robots" {
  type          = "postgres"
  name          = "pg-robots"
  url           = "${local.hosts.postgres}:5432"
  
  database_name = postgresql_database.robots.name
  username      = postgresql_role.arig.name
  json_data_encoded = jsonencode({
    sslmode = "disable"
  })
  secure_json_data_encoded = jsonencode({
    password      = postgresql_role.arig.password
  })
}
