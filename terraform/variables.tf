# определение имени проекта
variable project {
  description = "Project ID"
}

# определение региона
variable region {
  description = "Region"
  default = "europe-west1"
}

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

# количество узлов
variable node_count {
  default = "1"
}

# определение образа диска ВМ
variable disk_image {
  description = "Disk image"
}