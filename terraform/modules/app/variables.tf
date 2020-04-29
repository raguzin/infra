# определение зоны
variable zone {
  description = "Zone"
  default = "europe-west1-d"
}

# определение ssh-ключа
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default = "reddit-app-base"
}