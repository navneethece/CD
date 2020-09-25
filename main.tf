terraform {
  backend "s3" {
    bucket  = "navneeth-statefile"
    key  = "terraform/state"
    region = "us-east-1"
#   access_key = "XXXXXXXXXXXXXXXXXXXXXX"
#   secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  }
}

provider "aws" {
  region = "us-east-1"
}
data "aws_ami" "navneethami"{
  most_recent = true
  owners =["self"]
  filter {
    name = "name"
    values = ["navneeth-my-ubuntu-*"]
    }
  }
resource "aws_instance" "navneethvm1" {
  ami = data.aws_ami.example.id
  key_name = "navneethkp"
  instance_type = "t2.micro"

  tags = {
    Name = "navneethvm1"
    Env = "Prod"
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > /etc/ansible/hosts"
  }
 
provisioner "remote-exec" {
    inline = [
     "touch /tmp/navneeth"
     ]
 connection {
    type     = "ssh"
    user     = "ubuntu"
    insecure = "true"
    private_key = "${file("/tmp/navneethkp.pem")}"
    host     =  aws_instance.navneethvm1.public_ip
  }
}
}

output "myawsserver-ip" {
  value = "${aws_instance.navneethvm1.public_ip}"
}
