terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.13.0"
    }
  }
}

# provider "docker" {
#   host    = "npipe:////.//pipe//docker_engine"
# }

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  # name  = "tutorial"
  name  = var.container_name # Or you can run this command: terraform apply -var "container_name=YetAnotherName"
  ports {
    internal = 80
    # external = 8000
    external = 8080
  }
}