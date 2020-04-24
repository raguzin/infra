<h1>ИНФРАСТРУКТУРА КАК КОД (IaC)</h1>
<p>Тестирование различных приложений, утилит и фреймворков для управления инфраструктурой</p>


<h2>PACKER</h2>
<p>Для тестового приложения собирается baked-образ VM с предустановленными Ruby и MongoDB.</p>

<p><b>ubuntu16.json</b> - Packer шаблон, содержащий описание образа ВМ base, который мы хотим создать.
    <b>immutable.json</b> - Packer шаблон, содержащий описание образа ВМ full, в образе уже развернуто приложение puma.
    systed unit не создан.
    <b>builders</b> секция отвечает за создание ВМ для билда и создание машинного образа в GCP.
    <b>provisioners</b> секция устанавливает нужное ПО, производит настройку системы и конфигурацию приложений на
    созданной ВМ.
    <b>install_mongodb.sh и install_ruby.sh</b> - bash скрипты для установки ruby и mongodb в baked-образ.
    <b>deploy_app.sh</b> - bash скрипт для установки прилоежния puma.</p>

<p><b>Параметры для шаблона:</b>
    • ID проекта (обязательно)
    • source_image_family (обязательно)
    • machine_type
    "Обязательно" означает, что пользовательская переменная должна быть обязательна для определения и не иметь значения
    по умолчанию.
    Пользовательские переменные определяются в самом шаблоне, в файле <b>variables.json</b> задаются обязательные
    переменные, либо переопределяются.
    Для примера добавлен файл с переменными variables.json.example.</p>

<p><b>Проверка ошибок:</b>
    для Linux:
    $ packer validate -var-file=variables.json ubuntu16.json
    или
    $ packer validate -var-file=variables_immutable.json immutable.json
    для Windows:
    packer validate -var-file variables.json ubuntu16.json
    или
    $ packer validate -var-file variables_immutable.json immutable.json</p>

<p><b>Запуск создания образа:</b>
    для Linux:
    $ packer build -var-file=variables.json ubuntu16.json
    или
    $ packer build -var-file=variables_immutable.json immutable.json
    для Windows:
    packer build -var-file variables.json ubuntu16.json
    или
    $ packer build -var-file variables_immutable.json immutable.json</p>

<p><b>Создание Instance в GCP:</b>
    gcloud compute --project=<project_id> instances create reddit-app --zone=europe-west1-d --machine-type=f1-micro
        --subnet=default --tags=puma-server --image=<reddit-base-or-full-image> --boot-disk-size=10GB
            --boot-disk-type=pd-standard --boot-disk-device-name=reddit-app</p>