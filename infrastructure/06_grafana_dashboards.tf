resource "grafana_folder" "robots" {
  title = "Robots"
}

resource "grafana_dashboard" "robot_asserv_propulsions" {
  config_json = file("dashboards/grafana-robot-asserv-propulsions.json")
  folder      = grafana_folder.robots.uid
}

resource "grafana_dashboard" "robot_tasks" {
  config_json = file("dashboards/grafana-robot-tasks.json")
  folder      = grafana_folder.robots.uid
}

resource "grafana_dashboard" "robot_match" {
  config_json = file("dashboards/grafana-robot-match.json")
  folder      = grafana_folder.robots.uid
}
