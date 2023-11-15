resource "yandex_vpc_security_group" "inner-sg" {
  name              = "inner-sg"
  description       = "allow any connection from inner subnets"
  network_id        = "${yandex_vpc_network.net1.id}"

  ingress {
    protocol        = "ANY"
    v4_cidr_blocks  = ["192.168.11.0/24", 
                       "192.168.12.0/24", 
                       "192.168.13.0/24"
                      ]
    port            = 80
  }

  ingress {
    protocol        = "TCP"
    description     = "ssh"
    v4_cidr_blocks  = ["192.168.11.0/24", 
                       "192.168.12.0/24", 
                       "192.168.13.0/24"
                      ]
    port            = 22
  }
  
  ingress {
    protocol        = "ANY"
    description     = "allow node exporter"
    v4_cidr_blocks  = ["0.0.0.0/0"]
    port            = 9100
  }

  ingress {
    protocol        = "ANY"
    description     = "allow nginxlog exporter"
    v4_cidr_blocks  = ["0.0.0.0/0"]
    port            = 4040
  }

  ingress {
    protocol        = "ICMP"
    description     = "allow ping"
    v4_cidr_blocks  = ["0.0.0.0/0"]
  }
  egress {
    protocol        = "ANY"
    description     = "any connection"
    v4_cidr_blocks  = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "balancer-sg" {
  name              = "balancer-sg"
  description       = "public balancer"
  network_id        = "${yandex_vpc_network.net1.id}"

  ingress {
    protocol            = "ANY"
    description         = "Helth checks"
    v4_cidr_blocks      = ["0.0.0.0/0"]
    predefined_target   = "loadbalancer_helthchecks"
  }

  ingress {
    protocol        = "TCP"
    description     = "http connect"
    v4_cidr_blocks  = ["0.0.0.0/0"]
    port            = 80
  }

  ingress {
    protocol        = "ICMP"
    description     = "allow ping"
    v4_cidr_blocks  = ["0.0.0.0/0"]
  }

  egress {
    protocol        = "ANY"
    description     = "any connection"
    v4_cidr_blocks  = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "bastion-sg" {
  name              = "bastion-sg"
  description       = "SSH access bastion"
  network_id        = "${yandex_vpc_network.net1.id}"

  ingress {
    protocol        = "TCP"
    description     = "ssh"
    v4_cidr_blocks  = ["0.0.0.0/0"]
    port            = 22
  }

  ingress {
    protocol        = "ICMP"
    description     = "allow ping"
    v4_cidr_blocks  = ["0.0.0.0/0"]
  }

  egress {
    protocol        = "ANY"
    description     = "any connection"
    v4_cidr_blocks  = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "logs-sg" {
  name              = "logs-sg"
  description       = "logs hosts access"
  network_id        = "${yandex_vpc_network.net1.id}"

  ingress {
    protocol        = "ANY"
    description     = "allow elastic"
    v4_cidr_blocks  = ["0.0.0.0/0"]
    port            = 9200
  }


  ingress {
    protocol        = "ANY"
    description     = "allow kibana"
    v4_cidr_blocks  = ["0.0.0.0/0"]
    port            = 5601
  }

  ingress {
    protocol        = "ANY"
    description     = "allow node exporter"
    v4_cidr_blocks  = ["0.0.0.0/0"]
    port            = 9100
  }

  ingress {
    protocol        = "ANY"
    description     = "allow nginxlog exporter"
    v4_cidr_blocks  = ["0.0.0.0/0"]
    port            = 4040
  }
  ingress {
    protocol        = "ICMP"
    description     = "allow ping"
    v4_cidr_blocks  = ["0.0.0.0/0"]
  }

  egress {
    protocol        = "ANY"
    description     = "any connection"
    v4_cidr_blocks  = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "monit-sg" {
  name              = "monit-sg"
  description       = "monitoring host access"
  network_id        = "${yandex_vpc_network.net1.id}"

  ingress {
    protocol        = "ANY"
    description     = "allow promet"
    v4_cidr_blocks  = ["0.0.0.0/0"]
    port            = 9090
  }
  
  ingress {
    protocol        = "ANY"
    description     = "allow grafana"
    v4_cidr_blocks  = ["0.0.0.0/0"]
    port            = 3000
  }

  ingress {
    protocol        = "ANY"
    description     = "allow node exporter"
    v4_cidr_blocks  = ["0.0.0.0/0"]
    port            = 9100
  }

  ingress {
    protocol        = "ANY"
    description     = "allow nginxlog exporter"
    v4_cidr_blocks  = ["0.0.0.0/0"]
    port            = 4040
  }

  ingress {
    protocol        = "ICMP"
    description     = "allow ping"
    v4_cidr_blocks  = ["0.0.0.0/0"]
  }

  egress {
    protocol        = "ANY"
    description     = "any connection"
    v4_cidr_blocks  = ["0.0.0.0/0"]
  }
}