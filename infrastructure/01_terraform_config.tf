// Terraform configuration
terraform {
  required_version = ">= 0.14.3, < 0.16.0"

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
