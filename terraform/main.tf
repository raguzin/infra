# НАСТРОЙКА GCP ПРОВАЙДЕРА
terraform {
  required_version = "0.12.24"
}

provider "google" {
  version = "2.5.0"
  project = var.project
  region  = var.region
  zone    = var.zone
}

#provider "google-beta" {
#  project     = var.project
#  region      = var.region
#  zone        = var.zone
#}