
# VARIABLES
variable "server_ip" {}
variable "private_key_path" {}
variable "server_username" {}
variable "server_hostname" {}



# PROVIDERS
resource "null_resource" "upgrade-packages" {
   connection {
     type = "ssh"
     user = "${var.server_username}"
     private_key = "${var.private_key_path}"
     host = "${var.server_ip}"
     agent = false
     timeout = "10s"
   }

   provisioner "remote-exec" {
     inline = [
       "sudo apt-get -y update; sudo apt-get -y dist-upgrade ; sudo apt-get -y install nginx;"
     ]
   }

 }

 # OUTPUT
output "ip" {
    value = "${server_ip}"
}