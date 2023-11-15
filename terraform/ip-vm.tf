resource "local_file" "ip-vm" {
  content = <<-EOT
    [elastic]
    ${yandex_compute_instance.elastic.network_interface.0.ip_address} ansible_user=grigoryev ansible_ssh_private_key_file=/home/grigoryev/.ssh/id_ed25519 ansible_connection=ssh
    [gr]
    ${yandex_compute_instance.gr.network_interface.0.ip_address} ansible_user=grigoryev ansible_ssh_private_key_file=/home/grigoryev/.ssh/id_ed25519 ansible_connection=ssh
    [kb]
    ${yandex_compute_instance.kb.network_interface.0.ip_address} ansible_user=grigoryev ansible_ssh_private_key_file=/home/grigoryev/.ssh/id_ed25519 ansible_connection=ssh
    [pr]
    ${yandex_compute_instance.pr.network_interface.0.ip_address} ansible_user=grigoryev ansible_ssh_private_key_file=/home/grigoryev/.ssh/id_ed25519 ansible_connection=ssh
    [servers]
    ${yandex_compute_instance.s1.network_interface.0.ip_address} ansible_user=grigoryev ansible_ssh_private_key_file=/home/grigoryev/.ssh/id_ed25519 ansible_connection=ssh
    ${yandex_compute_instance.s2.network_interface.0.ip_address} ansible_user=grigoryev ansible_ssh_private_key_file=/home/grigoryev/.ssh/id_ed25519 ansible_connection=ssh


    ssh ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} 

    ssh -i ~/.ssh/id_ed25519 -J grigoryev@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} grigoryev@192.168.


    [bastion]
    ${yandex_compute_instance.bastion.network_interface.0.ip_address} bastion
    [elasticsearch]
    ${yandex_compute_instance.elastic.network_interface.0.ip_address} elastic
    [grafana]
    ${yandex_compute_instance.gr.network_interface.0.ip_address} grafana
    [kibana]
    ${yandex_compute_instance.kb.network_interface.0.ip_address} kibana
    [prometheus]
    ${yandex_compute_instance.pr.network_interface.0.ip_address} prom
    [servers]
    ${yandex_compute_instance.s1.network_interface.0.ip_address} server1
    ${yandex_compute_instance.s2.network_interface.0.ip_address} server2


    EOT
  filename = "ip-vm"
}













