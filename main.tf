terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "ec2_instances" {
  source  = "./modules/ec2-instances"

  instances_count = var.aws_instances_count
  instance_type = var.aws_instance_type
  ami = var.aws_ami
  key_name = var.aws_key_name
}

resource "local_file" "hosts" {
  content     = "[jenkins] \n${module.ec2_instances.instances_public_ip.0} \n[docker] \n${module.ec2_instances.instances_public_ip.1}"
  filename = "/etc/ansible/hosts"
  file_permission = "400"
}

resource "null_resource" "ansible" {
  provisioner "remote-exec" {
    connection {
      host = module.ec2_instances.instances_public_ip.0
      user = "ec2-user"
      private_key = file("./${var.aws_key_name}.pem")
    }
    
    inline = ["echo 'connected to first'"]
  }

  provisioner "remote-exec" {
    connection {
      host = module.ec2_instances.instances_public_ip.1
      user = "ec2-user"
      private_key = file("./${var.aws_key_name}.pem")
    }

    inline = ["echo 'connected to second'"]
  }
  
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False sudo ansible-playbook ./ansible/main.yml --private-key ./${var.aws_key_name}.pem"
  }
}
