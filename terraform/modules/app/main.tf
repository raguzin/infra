resource "google_compute_instance" "app" {
    name = "reddit-app"
    machine_type = "g1-small"
    zone = var.zone
    tags = ["reddit-app"]
    boot_disk {
        initialize_params {
            image = var.app_disk_image
        }
    }
    network_interface {
        network = "default"
        access_config {
            nat_ip = google_compute_address.app_ip.address
        }
    }

    # параметры подключения провижинеров
#    connection {
#        type  = "ssh"
#        user  = "appuser"
#        agent = true
        # путь до приватного ключа
        #private_key = file(var.private_key_path)
#        host = google_compute_instance.app.network_interface.0.access_config.0.nat_ip
#    }
    # настройка приложения puma
#    provisioner "file" {
#        source      = "files/puma.service"
#        destination = "/tmp/puma.service"
#    }
#    provisioner "remote-exec" {
#        script = "files/deploy.sh"
#    }
}

# Правило для app
resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}