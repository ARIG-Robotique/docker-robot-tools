# Configuration PostgreSQL #
############################
resource "postgresql_role" "arig" {
  name     = local.users.arig_username
  password = local.users.arig_password
  login    = true
}

resource "postgresql_database" "robots" {
  name              = local.bddName
  owner             = postgresql_role.arig.name
  allow_connections = true
}
