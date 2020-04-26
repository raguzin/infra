# СОЗДАНИЕ ВИРТУАЛЬНЫХ МАШИН

resource "google_compute_instance" "app" {
  count        = var.node_count 
  name         = "reddit-app${count.index}"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = ["reddit-app"]
  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }
  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"
    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  # параметры подключения провижинеров
  connection {
    type  = "ssh"
    user  = "appuser"
    agent = true
    # путь до приватного ключа
    #private_key = file(var.private_key_path)
    host = google_compute_instance.app[count.index].network_interface.0.access_config.0.nat_ip
  }
  # настройка приложения puma
  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}