// Terraform configuration
terraform {
  required_version = ">= 1.0.3, < 2.0.0"

  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "1.8.1"
    }

    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.11.2"
    }
  }
}
