resource "yandex_compute_instance" "bastion" {
  name                  = "bastion"
  zone                  = "ru-central1-c"

  resources {
    cores               = 2
    memory              = 2
  }

  boot_disk {
    initialize_params {
      image_id          = "fd8a67rb91j689dqp60h"
      size              = 10      
    }
  }

  network_interface {
    subnet_id           = "${yandex_vpc_subnet.net13.id}"
    security_group_ids  = [yandex_vpc_security_group.inner-sg.id, yandex_vpc_security_group.bastion-sg.id] 
    ip_address          = "192.168.13.13"
    nat                 = true
  }
  
  metadata = {
    user-data           = "${file("./mbastion.yaml")}"
  }

  scheduling_policy {
    preemptible         = true
  }  
}

resource "yandex_compute_instance" "s1" {
  name                  = "s1"
  zone                  = "ru-central1-a"

  resources {
    cores               = 2
    memory              = 2
  }

  boot_disk {
    initialize_params {
      image_id          = "fd8a67rb91j689dqp60h"
    }
  }

  network_interface {
    subnet_id           = "${yandex_vpc_subnet.net11.id}"
    security_group_ids  = [yandex_vpc_security_group.inner-sg.id]
    ip_address          = "192.168.11.11" 
    nat                 = true
  }
  
  metadata = {
    user-data           = "${file("./ms1.yaml")}"
  }

  scheduling_policy {
    preemptible         = true
  }  
}
 
resource "yandex_compute_instance" "s2" {
  name                  = "s2"
  zone                  = "ru-central1-b"

  resources {
    cores               = 2
    memory              = 2
  }

  boot_disk {
    initialize_params {
      image_id          = "fd8a67rb91j689dqp60h"
    }
  }

  network_interface {
    subnet_id           = "${yandex_vpc_subnet.net12.id}"
    security_group_ids  = [yandex_vpc_security_group.inner-sg.id] 
    ip_address          = "192.168.12.12"
    nat                 = true
  }
  
  metadata = {
    user-data           = "${file("./ms2.yaml")}"
  }

  scheduling_policy {
    preemptible         = true
  }  
}

resource "yandex_compute_instance" "elastic" {
  name                  = "elastic"
  zone                  = "ru-central1-b"

  resources {
    cores               = 2
    memory              = 2
  }

  boot_disk {
    initialize_params {
      image_id          = "fd8a67rb91j689dqp60h"
      size              = 10      
    }
  }

  network_interface {
    subnet_id           = "${yandex_vpc_subnet.net12.id}"
    security_group_ids  = [yandex_vpc_security_group.inner-sg.id, yandex_vpc_security_group.logs-sg.id] 
    ip_address          = "192.168.12.13"
    nat                 = true
  }
  
  metadata = {
    user-data           = "${file("./melastic.yaml")}"
  }

  scheduling_policy {
    preemptible         = true
  }  
}

resource "yandex_compute_instance" "kb" {
  name                  = "kb"
  zone                  = "ru-central1-a"

  resources {
    cores               = 2
    memory              = 2
  }

  boot_disk {
    initialize_params {
      image_id          = "fd8a67rb91j689dqp60h"
      size              = 10
    }
  }

  network_interface {
    subnet_id           = "${yandex_vpc_subnet.net11.id}"
    security_group_ids  = [yandex_vpc_security_group.inner-sg.id, yandex_vpc_security_group.logs-sg.id] 
    ip_address          = "192.168.11.12"
    nat                 = true
  }
  
  metadata = {
    user-data           = "${file("./mkb.yaml")}"
  }

  scheduling_policy {
    preemptible         = true
  }  
}

resource "yandex_compute_instance" "gr" {
  name                  = "gr"
  zone                  = "ru-central1-a"

  resources {
    cores               = 2
    memory              = 2
  }

  boot_disk {
    initialize_params {
      image_id          = "fd8a67rb91j689dqp60h"
      size              = 10      
    }
  }

  network_interface {
    subnet_id           = "${yandex_vpc_subnet.net11.id}"
    security_group_ids  = [yandex_vpc_security_group.inner-sg.id, yandex_vpc_security_group.monit-sg.id]
    ip_address          = "192.168.11.13"
    nat                 = true
  }
  
  metadata = {
    user-data           = "${file("./mgr.yaml")}"
  }

  scheduling_policy {
    preemptible         = true
  }  
}

#-------Prometheus------#
resource "yandex_compute_instance" "pr" {
  name                  = "pr"
  zone                  = "ru-central1-b"

  resources {
    cores               = 2
    memory              = 2
  }

  boot_disk {
    initialize_params {
      image_id          = "fd8a67rb91j689dqp60h"
      size              = 10      
    }
  }

  network_interface {
    subnet_id           = "${yandex_vpc_subnet.net12.id}"
    security_group_ids  = [yandex_vpc_security_group.inner-sg.id, yandex_vpc_security_group.monit-sg.id]
    ip_address          = "192.168.12.14"
    nat                 = true
  }
  
  metadata = {
    user-data           = "${file("./mpr.yaml")}"
  }

  scheduling_policy {
    preemptible         = true
  }  
}
