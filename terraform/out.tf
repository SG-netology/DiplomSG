#output "server1" {
#  value = yandex_compute_instance.s1.network_interface.0.nat_ip_address
#}

#output "server2" {
#  value = yandex_compute_instance.s2.network_interface.0.nat_ip_address
#}

output "Grafana" {
  value = yandex_compute_instance.gr.network_interface.0.nat_ip_address
} 

#output "Prometheus" {
#  value = yandex_compute_instance.pr.network_interface.0.nat_ip_address
#}

#output "Elasticsearch" {
#  value = yandex_compute_instance.elastic.network_interface.0.nat_ip_address
#} 

output "Kibana" {
  value = yandex_compute_instance.kb.network_interface.0.nat_ip_address
}

output "Bastion" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}

#-------Output PRIV------#
output "server1-nat" {
  value = yandex_compute_instance.s1.network_interface.0.ip_address
}

output "server2-nat" {
  value = yandex_compute_instance.s2.network_interface.0.ip_address
}

output "Grafana-nat" {
  value = yandex_compute_instance.gr.network_interface.0.ip_address
} 

output "Prometheus-nat" {
  value = yandex_compute_instance.pr.network_interface.0.ip_address
} 

output "Elastic-nat" {
  value = yandex_compute_instance.elastic.network_interface.0.ip_address
} 

output "Kibana-nat" {
  value = yandex_compute_instance.kb.network_interface.0.ip_address
} 

output "Bastion-nat" {
  value = yandex_compute_instance.bastion.network_interface.0.ip_address
} 

output "L7_load_balancer-pub" {
  value = yandex_alb_load_balancer.lbalans.listener[0].endpoint[0].address[0].external_ipv4_address
}