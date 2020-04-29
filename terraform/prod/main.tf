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

module "app" {
  source          = "../modules/app"
  public_key_path = var.public_key_path
  zone            = var.zone
  app_disk_image  = var.app_disk_image
}

module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  zone            = var.zone
  db_disk_image   = var.db_disk_image
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["46.242.14.13/32"]
}