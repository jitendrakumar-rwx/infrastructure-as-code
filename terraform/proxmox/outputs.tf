############################################################
# Per-VM LAN IP from guest agent
############################################################
locals {
  vm_ips = {
    for vm in proxmox_virtual_environment_vm.ubuntu_vm :
    vm.name => {
      lan = try([for ip in flatten(vm.ipv4_addresses) : ip if !startswith(ip, "127.")][0], "pending")
    }
  }
}

############################################################
# One-line report per VM:
#   ubuntu-vm-1  192.168.10.151
############################################################
output "vm_report" {
  description = "Per-VM line: name + LAN IP"
  value = [
    for name, ips in local.vm_ips :
    format("%-30s %s", name, ips.lan)
  ]
}

############################################################
# Structured version (name -> { lan })
############################################################
output "vms" {
  description = "LAN IP per VM"
  value       = local.vm_ips
}
