terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

variable "db_password" {
  type      = string
  sensitive = true # Protects password logs from exposure
}

variable "db_name" {
  type    = string
  default = "postgres_db"
}

# 1. Download the Postgres Image
resource "docker_image" "postgres" {
  name          = "postgres:14-alpine" # Alpine version is already lightweight (~30MB)
  keep_locally = true
}

# 2. Run the Postgres Server on the kind network
resource "docker_container" "db" {
  name  = var.db_name
  image = docker_image.postgres.image_id
  
  env = [
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_USER=postgres"
  ]
  
  network_mode = "kind"

  # --- Resource Constraints (Easy on your machine) ---
  memory     = 512 # Limit RAM to 512 MB (Default is unlimited)
  cpu_shares = 512 # Lower CPU priority relative to other containers
}
