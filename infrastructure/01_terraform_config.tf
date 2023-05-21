// Terraform configuration
terraform {
  required_version = ">= 1.4.6, < 2.0.0"

  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "1.40.1"
    }

    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.19.0"
    }
  }
}
