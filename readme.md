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
    <b>deploy_app.sh</b> - bash скрипт для установки прилоежния puma.<br>
    <b>app.json</b> - Packer шаблон для создания образа app. Provision с помощью Ansible playbook <b>ansible/packer_app.yml</b>.<br>
    <b>db.json</b> - Packer шаблон для создания образа db. Provision с помощью Ansible playbook <b>ansible/packer_db.yml</b>.</p>

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
<p>Создаются две ВМ из подготовленного в Packer образа с reddit-app-base. Пока не настроено обращение из ВМ app к базе данных в ВИ db.</p>
<p>Соданы два окружения stage и prod. В прафилах файрвола в окружении stage настроен доступ к ВМ со всех адресов, в окружении prod - с конкретного адреса.</p>
<br>
<p>Созданы 3 модуля:<br>
- <b>app</b> - ВМ с приложением<br>
- <b>db</b> - ВМ с базой данных<br>
- <b>vpc</b> - правила натсрофки сети (firewall).</p>

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
    <b>$ terraform init</b> - инициализация.<br>
    <b>$ terraform providers</b> - отображение провайдера.<br>
    <b>$ terraform get</b> - импорт модулей.<br>
    <b>$ terraform plan</b> - планирование развертывания.<br>
    <b>$ terraform apply</b> - применение развертывания.<br>
    <b>$ terraform destroy</b> - удаление развертывания.<br>
    <b>$ terraform fmt</b> - форматирвоание конфигурационных файлов.</p>
<br>
<br>
<h2>ANSIBLE</h2>
<p>С помощью Terraform разворачивает инфрсатруктура stage в gcp.</p>
<p><b>Инвентаризация.</b> В Ansible создается сначала статический файл инвентаризации и проверяется взаимодействие с развернутыми машнами. Затем настраиваетс динамическая инвентразиация с помощью модуля gcp_compute для работы с GCE. Для этого:<br>
Содается файл <b>gcp.yml</b>, содержайщий парметры инвентразации.<br>
Создается файл <b>gcp.ini</b>, содержащий информацию для подключения с проекту GCP через serviceaccoun.<br>
В файле <b>ansible.cfg</b> в модуле <b>[inventory]</b> указывается <b>enable_plugins = gcp_compute</b>.</p>
<p><b>Playbook'и:</b><br>
<b>reddit_app_one_play.yml</b> - один playbook, один сценарий. Работа с тегами.<br>
<b>reddit_app_multiple_plays.yml</b> - один playbook, несколько сценариев. Работа с тегами.<br>
<b>site.yml</b> - главный playbook, который будет включать в себя три:<br>
<b>app.yml</b> - playbook для настройки сервера приложений.<br>
<b>db.yml</b> - playbook для настройки сервера БД.<br>
<b>deloy.yml</b> - playbook, для развертывания приложения.<br></p>