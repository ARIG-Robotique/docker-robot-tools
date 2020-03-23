# Configuration des providers #
###############################

provider "grafana" {
  url = "http://${var.hosts["grafana"]}/"
  auth = "${var.users["admin_username"]}:${var.users["admin_password"]}"
}

provider "influxdb" {
  url = "http://${var.hosts["influxdb"]}/"
  username = "${var.users["root_username"]}"
  password = "${var.users["root_password"]}"
}

provider "postgresql" {
  host = "${var.hosts["postgres"]}"
  username = "${var.users["postgres_username"]}"
  password = "${var.users["postgres_password"]}"
  sslmode = "disable"
}
