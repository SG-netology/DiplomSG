resource "yandex_compute_snapshot_schedule" "snap" {
  name = "snap"

  schedule_policy {
	expression = "0 2 * * *"
  }
  
  retention_period = "168h"


  snapshot_spec {
	  description = "allbackup"
  }

  disk_ids = [  yandex_compute_instance.s1.boot_disk[0].device_name,
                yandex_compute_instance.s2.boot_disk[0].device_name,
                yandex_compute_instance.elastic.boot_disk[0].device_name,
                yandex_compute_instance.kb.boot_disk[0].device_name,
                yandex_compute_instance.gr.boot_disk[0].device_name,
                yandex_compute_instance.pr.boot_disk[0].device_name,
                yandex_compute_instance.bastion.boot_disk[0].device_name
              ]
}