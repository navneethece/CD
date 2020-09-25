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

resource "aws_instance" "navneethjkvm1" {
  ami = "ami-08f6d36d2fa808eac"
  key_name = "navneethkp"
  instance_type = "t2.micro"

  tags = {
    Name = "navneethvm1"
    Env = "Prod"
  }
  provisioner "local-exec" {
    command = "echo The servers IP address is ${self.public_ip} && echo ${self.private_ip} myawsserver >> /etc/hosts"
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
