variable "key_name" {
  default = "es-keyss"
}
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "es-key-pair" {
  public_key = tls_private_key.example.public_key_openssh
  key_name   = var.key_name
}
resource "local_file" "key-pair-pvt-file" {
  filename = "key144.pem"
  content  = tls_private_key.example.private_key_pem
}

resource "aws_instance" "elastic_instance" {
  ami                = var.ami_id
  instance_type      = var.instance_type
  key_name           = aws_key_pair.es-key-pair.key_name
  subnet_id          = var.dmz_subnet
  security_groups    = ["${var.els_sg}"]
 
  provisioner "local-exec" {
     command = "chmod 400 key144.pem"
  }

  provisioner "remote-exec" {
    # Install Python for Ansible
     inline = [
            "sudo apt-get -y install  python",
            "sudo apt-get -y update",
            "sudo apt-get -y install less",
           ]

     connection {
       host        =  self.public_ip
       type        = "ssh"
       user        = "admin"
       private_key = tls_private_key.example.private_key_pem
    }
 }


  provisioner "local-exec" {
     command = "ansible-playbook -i '${self.public_ip},' --ssh-common-args='-o StrictHostKeyChecking=no' -u admin --private-key ./key144.pem elastic-ansible.yml" 
  }
}

