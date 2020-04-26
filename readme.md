<h1>ИНФРАСТРУКТУРА КАК КОД (IaC)</h1>
<p>Тестирование различных приложений, утилит и фреймворков для управления инфраструктурой</p>


<h2>PACKER</h2>
<p>Для тестового приложения собирается baked-образ VM с предустановленными Ruby и MongoDB.</p>

<p><b>ubuntu16.json</b> - Packer шаблон, содержащий описание образа ВМ base, который мы хотим создать.<br>
    <b>immutable.json</b> - Packer шаблон, содержащий описание образа ВМ full, в образе уже развернуто приложение puma.
    systed unit не создан.<br>
    <b>builders</b> секция отвечает за создание ВМ для билда и создание машинного образа в GCP.<br>
    <b>provisioners</b> секция устанавливает нужное ПО, производит настройку системы и конфигурацию приложений на
    созданной ВМ.<br>
    <b>install_mongodb.sh и install_ruby.sh</b> - bash скрипты для установки ruby и mongodb в baked-образ.<br>
    <b>deploy_app.sh</b> - bash скрипт для установки прилоежния puma.</p>

<p><b>Параметры для шаблона:</b><br>
    • ID проекта (обязательно)<br>
    • source_image_family (обязательно)<br>
    • machine_type<br>
    "Обязательно" означает, что пользовательская переменная должна быть обязательна для определения и не иметь значения
    по умолчанию.<br>
    Пользовательские переменные определяются в самом шаблоне, в файле <b>variables.json</b> задаются обязательные
    переменные, либо переопределяются.<br>
    Для примера добавлен файл с переменными variables.json.example.</p>

<p><b>Проверка ошибок:</b><br>
    для Linux:<br>
    $ packer validate -var-file=variables.json ubuntu16.json<br>
    или<br>
    $ packer validate -var-file=variables_immutable.json immutable.json<br>
    для Windows:<br>
    packer validate -var-file variables.json ubuntu16.json<br>
    или<br>
    $ packer validate -var-file variables_immutable.json immutable.json</p>

<p><b>Запуск создания образа:</b><br>
    для Linux:<br>
    $ packer build -var-file=variables.json ubuntu16.json<br>
    или<br>
    $ packer build -var-file=variables_immutable.json immutable.json<br>
    для Windows:<br>
    packer build -var-file variables.json ubuntu16.json<br>
    или<br>
    $ packer build -var-file variables_immutable.json immutable.json</p>

<p><b>Создание Instance в GCP:</b><br>
    gcloud compute --project=<project_id> instances create reddit-app --zone=europe-west1-d --machine-type=f1-micro
        --subnet=default --tags=puma-server --image=<reddit-base-or-full-image> --boot-disk-size=10GB
            --boot-disk-type=pd-standard --boot-disk-device-name=reddit-app</p>
<br>
<br>
<h2>TERRAFORM</h2>
<p>Для тестового приложения создаются две ВМ из подготовленного в Packer образа с reddit-app.</p><br>
<br>
<p><b>main.tf</b> - основной файл terraform, описывающий провайдер google для взаимодействия с GCP.<br>
    <b>network-firewall.tf</b> - описание настроек firewall.<br>
    <b>vm.tf</b> - файл, описывающий создание ВМ.<br>
    <b>lb.tf</b> - файл, описывающий создание балансировщика для порта tcp/9292.<br>
    <b>variables.tf</b> - файл, описывающий переменные.<br>
    <b>terraforms.tfvars</b> - файл, содержащий значения переменных (для примера terraforms.tfvars.example).<br>
    <b>outputs.tf</b> - файл, содержащий выходные значения.<br>
    <b>deploy.sh</b> - bash скрипт для развертывания приложения puma.<br>
    <b>puma.service</b> - systemd unit файл для упралвения работой приложения.</p>
<br>
<p><b>Команды для запуска:</b><br>
    <b>$ terraform plan</b> - планирование развертывания.<br>
    <b>$ terraform apply</b> - применение развертывания.<br>
    <b>$ terraform destroy</b> - удаление развертывания.<br>
    <b>$ terraform fmt</b> - форматирвоание конфигурационных файлов.</p>