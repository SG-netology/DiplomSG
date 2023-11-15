
resource "yandex_alb_target_group" "tgroup" {
  name            = "tgroup"

  target {
    subnet_id     = yandex_vpc_subnet.net11.id
    ip_address    = yandex_compute_instance.s1.network_interface.0.ip_address
  }

  target {
    subnet_id     = yandex_vpc_subnet.net12.id
    ip_address    = yandex_compute_instance.s2.network_interface.0.ip_address
  }
}

resource "yandex_alb_backend_group" "bgroup" {
  name                = "bgroup"

  http_backend {
    name              = "http-bgroup"
    target_group_ids  = ["${yandex_alb_target_group.tgroup.id}"]
    port              = 80
    healthcheck {
      timeout         = "1s"
      interval        = "1s"
      http_healthcheck {
        path          = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "router" {
  name                    = "router"
}

#-------VIRTUAL-HOST------#
resource "yandex_alb_virtual_host" "vhost" {
  name                    = "vhost"
  http_router_id          = yandex_alb_http_router.router.id
  route {
    name                  = "route-1"
    http_route {
      http_match {
        path {
          prefix          = "/"
        }
      }       
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.bgroup.id
      }
    }
  }
}

#-------L7-LOAD-BALANCER------#

resource "yandex_alb_load_balancer" "lbalans" {
  name                    = "lbalans"
  network_id              = yandex_vpc_network.net1.id
  security_group_ids      = [yandex_vpc_security_group.inner-sg.id, yandex_vpc_security_group.balancer-sg.id]  

  allocation_policy {
    location {
      zone_id             = "ru-central1-a"
      subnet_id           = yandex_vpc_subnet.net11.id
    }

    location {
      zone_id             = "ru-central1-b"
      subnet_id           = yandex_vpc_subnet.net12.id
    }
  }

  listener {
    name                  = "listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports               = [ "80" ]
    }
    http {
      handler {
        http_router_id    = yandex_alb_http_router.router.id
      }
    }
  }
}