terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
provider "yandex" {
  token     = "y0_AgAEA7qj71WjAATuwQAAAADxcDYY2MIs3wNsQ2OdL2ufjxKtPJEV08Q"
  cloud_id  = "b1gcf4c4d2ihla07tt2n"
  folder_id = "b1grlbpsd18hc9gviifo"
}
resource "yandex_vpc_network" "net1" {
  name           = "net1"
}
resource "yandex_vpc_subnet" "net11" {
  name           = "net11"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net1.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}
resource "yandex_vpc_subnet" "net12" {
  name           = "net12"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.net1.id
  v4_cidr_blocks = ["192.168.12.0/24"]
}
resource "yandex_vpc_subnet" "net13" {
  name           = "net13"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.net1.id
  v4_cidr_blocks = ["192.168.13.0/24"]
}

#resource "yandex_vpc_gateway" "gate" {
#  name = "gate"
#  shared_egress_gateway {}
#}

resource "yandex_vpc_route_table" "route-table" {
  name       = "route-table"
  network_id = yandex_vpc_network.net1.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.bastion.network_interface.0.ip_address
#   gateway_id         = yandex_vpc_gateway.gate.id
  }
}
