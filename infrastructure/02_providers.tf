# Configuration des providers #
###############################

provider "grafana" {
  url  = "http://${local.hosts.grafana}/"
  auth = "${local.users.admin_username}:${local.users.admin_password}"
}

provider "postgresql" {
  host     = local.hosts.postgres
  username = local.users.postgres_username
  password = local.users.postgres_password
  sslmode = "disable"
}
