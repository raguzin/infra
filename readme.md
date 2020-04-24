ИНФРАСТРУКТУРА КАК КОД (IaC)
Тестирование различных приложений, утилит и фреймворков для управления инфраструктурой.


PACKER
Для тестового приложения собирается baked-образ VM с предустановленными Ruby и MongoDB. 

ubuntu16.json - Packer шаблон, содержащий описание образа ВМ base, который мы хотим создать.
immutable.json - Packer шаблон, содержащий описание образа ВМ full, в образе уже развернуто приложение puma. systed unit не создан.
builders секция отвечает за создание ВМ для билда и создание машинного образа в GCP.
provisioners секция устанавливает нужное ПО, производит настройку системы и конфигурацию приложений на созданной ВМ.
install_mongodb.sh и install_ruby.sh - bash скрипты для установки ruby и mongodb в baked-образ.
deploy_app.sh - bash скрипт для установки прилоежния puma

Параметры для шаблона:
• ID проекта (обязательно)
• source_image_family (обязательно)
• machine_type
"Обязательно" означает, что пользовательская переменная должна быть обязательна для определения и не иметь значения по умолчанию.
Пользовательские переменные определяются в самом шаблоне, в файле variables.json задаются обязательные переменные, либо переопределяются.
Для примера добавлен файл с переменными variables.json.example.

Проверка ошибок:
для Linux:
$ packer validate -var-file=variables.json ubuntu16.json
или
$ packer validate -var-file=variables_immutable.json immutable.json
для Windows:
packer validate -var-file variables.json ubuntu16.json
или
$ packer validate -var-file variables_immutable.json immutable.json

Запуск создания образа:
для Linux:
$ packer build -var-file=variables.json ubuntu16.json
или
$ packer build -var-file=variables_immutable.json immutable.json
для Windows:
packer build -var-file variables.json ubuntu16.json
или
$ packer build -var-file variables_immutable.json immutable.json

Создание Instance
gcloud compute --project=<project_id> instances create reddit-app --zone=europe-west1-d --machine-type=f1-micro --subnet=default --tags=puma-server --image=<reddit-base-or-full-image> --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=reddit-app