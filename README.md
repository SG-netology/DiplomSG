##  Дипломная работа по профессии «Системный администратор»

### Содержание

* [Задача](#Задача)
* [Инфраструктура](#Инфраструктура)
    * [Сайт](#Сайт)
    * [Мониторинг](#Мониторинг)
    * [Логи](#Логи)
    * [Сеть](#Сеть)
---------
### Задача
Ключевая задача — разработать отказоустойчивую инфраструктуру для сайта, включающую мониторинг, сбор логов и резервное копирование основных данных. Инфраструктура должна размещаться в [Yandex Cloud](https://cloud.yandex.com/) и отвечать минимальным стандартам безопасности: запрещается выкладывать токен от облака в git. Используйте [инструкцию](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#get-credentials).

**ПРИМЕЧАНИЕ**: в этом дипломном задании используется система мониторинга Prometheus.

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

### Инфраструктура
Для развёртки инфраструктуры используйте Terraform и Ansible.  

Важно: используйте по-возможности **минимальные конфигурации ВМ**:2 ядра 20% Intel ice lake, 2-4Гб памяти, 10hdd, прерываемая. 

Так как прерываемая ВМ проработает не больше 24ч, после сдачи работы на проверку свяжитесь с вашим дипломным руководителем и договоритесь запустить инфраструктуру к указанному времени.

Ознакомьтесь со всеми пунктами из этой секции, не беритесь сразу выполнять задание, не дочитав до конца. Пункты взаимосвязаны и могут влиять друг на друга.

### Сайт
Создайте две ВМ в разных зонах, установите на них сервер nginx, если его там нет. ОС и содержимое ВМ должно быть идентичным, это будут наши веб-сервера.

Используйте набор статичных файлов для сайта. Можно переиспользовать сайт из домашнего задания.

Создайте [Target Group](https://cloud.yandex.com/docs/application-load-balancer/concepts/target-group), включите в неё две созданных ВМ.

Создайте [Backend Group](https://cloud.yandex.com/docs/application-load-balancer/concepts/backend-group), настройте backends на target group, ранее созданную. Настройте healthcheck на корень (/) и порт 80, протокол HTTP.

Создайте [HTTP router](https://cloud.yandex.com/docs/application-load-balancer/concepts/http-router). Путь укажите — /, backend group — созданную ранее.

Создайте [Application load balancer](https://cloud.yandex.com/en/docs/application-load-balancer/) для распределения трафика на веб-сервера, созданные ранее. Укажите HTTP router, созданный ранее, задайте listener тип auto, порт 80.

Протестируйте сайт
`curl -v <публичный IP балансера>:80` 

### Мониторинг
Создайте ВМ, разверните на ней Prometheus. На каждую ВМ из веб-серверов установите Node Exporter и [Nginx Log Exporter](https://github.com/martin-helmich/prometheus-nginxlog-exporter). Настройте Prometheus на сбор метрик с этих exporter.

Создайте ВМ, установите туда Grafana. Настройте её на взаимодействие с ранее развернутым Prometheus. Настройте дешборды с отображением метрик, минимальный набор — Utilization, Saturation, Errors для CPU, RAM, диски, сеть, http_response_count_total, http_response_size_bytes. Добавьте необходимые [tresholds](https://grafana.com/docs/grafana/latest/panels/thresholds/) на соответствующие графики.

### Логи
Cоздайте ВМ, разверните на ней Elasticsearch. Установите filebeat в ВМ к веб-серверам, настройте на отправку access.log, error.log nginx в Elasticsearch.

Создайте ВМ, разверните на ней Kibana, сконфигурируйте соединение с Elasticsearch.

### Сеть
Разверните один VPC. Сервера web, Prometheus, Elasticsearch поместите в приватные подсети. Сервера Grafana, Kibana, application load balancer определите в публичную подсеть.

Настройте [Security Groups](https://cloud.yandex.com/docs/vpc/concepts/security-groups) соответствующих сервисов на входящий трафик только к нужным портам.

Настройте ВМ с публичным адресом, в которой будет открыт только один порт — ssh. Настройте все security groups на разрешение входящего ssh из этой security group. Эта вм будет реализовывать концепцию bastion host. Потом можно будет подключаться по ssh ко всем хостам через этот хост.

### Резервное копирование
Создайте snapshot дисков всех ВМ. Ограничьте время жизни snaphot в неделю. Сами snaphot настройте на ежедневное копирование.

### Выполнение работы:

#### 1. Развертывание инфраструктуры

Используем Terraform для развертывания инфраструктуры на YandexCloud

![1](https://github.com/SG-netology/DiplomSG/blob/main/1.png)
![2](https://github.com/SG-netology/DiplomSG/blob/main/2.png)

Конфигурация ВМ, согласно рекомендуемой

Получаем сеть net1, подсети net11, net12, 7 ВМ, балансировщик, группы безопасности, back up дисков ВМ, Target Group, Backend Group, HTTP router.

![3](https://github.com/SG-netology/DiplomSG/blob/main/3.png)
![4](https://github.com/SG-netology/DiplomSG/blob/main/4.png)
![5](https://github.com/SG-netology/DiplomSG/blob/main/5.png)
![6](https://github.com/SG-netology/DiplomSG/blob/main/6.png)
![7](https://github.com/SG-netology/DiplomSG/blob/main/7.png)

#### 2. Установка программ

Используя Ansible, через ВМ bastion устанавливаем программы на остальные ВМ: Nginx на s1, s2, Elasticsearch на elastic, Kibana на kb, Grafana на gr, Prometheus на pr, на s1, s2 устанавливаются Node-Exporter и Nginx Log Exporter. Подключение к ВМ через SSH. Для экспорта плейбуков Ansible используется репозиторий: https://github.com/SG-netology/Ansible-set

![8](https://github.com/SG-netology/DiplomSG/blob/main/8.png)

Тестирование сайта (используем curl -v 158.160.130.88:80 (IP балансера) или в браузере)

![9](https://github.com/SG-netology/DiplomSG/blob/main/9.png)
![010](https://github.com/SG-netology/DiplomSG/blob/main/010.png)

На ВМ s1 и s2 проверяем Node-Exporter и Nginx log Exporter

![011](https://github.com/SG-netology/DiplomSG/blob/main/011.png)

На ВМ pr проверяем сбор информации Prometheus, используя команду curl http://192.168.12.14:9090/metrics

![012](https://github.com/SG-netology/DiplomSG/blob/main/012.png)

#### 3. Мониторинг

Доступ к Grafana: 158.160.120.209:3000 (на 17-11-2023) Логин: admin Пароль: qwerty
Прописываем настройки Prometheus, экспортируем Dashboard №1860 Node Exporter Full

![013](https://github.com/SG-netology/DiplomSG/blob/main/013.png)
![014](https://github.com/SG-netology/DiplomSG/blob/main/014.png)
![015](https://github.com/SG-netology/DiplomSG/blob/main/015.png)
![016](https://github.com/SG-netology/DiplomSG/blob/main/016.png)

Настройка THresholds

![017](https://github.com/SG-netology/DiplomSG/blob/main/017.png)

Доступ к Kibana: 158.160.114.193:5601 (на 17-11-2023)
Выбор параметров для просмотра в Discover

![018](https://github.com/SG-netology/DiplomSG/blob/main/018.png)

Добавление нового индекса в управлении Kibana

![019](https://github.com/SG-netology/DiplomSG/blob/main/019.png)

![020](https://github.com/SG-netology/DiplomSG/blob/main/020.png)

Проверка резервного копирования дисков ВМ в YandexCloud

![021](https://github.com/SG-netology/DiplomSG/blob/main/021.png)
![022](https://github.com/SG-netology/DiplomSG/blob/main/022.png)
