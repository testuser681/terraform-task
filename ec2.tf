resource "aws_instance" "corginstance" {
  ami                    = "ami-00dfe2c7ce89a450b"
  instance_type          = "t2.micro"
  key_name               = "My_key"
  monitoring             = true
  vpc_security_group_ids = ["sg-0856c1a7968986b0f"]
  subnet_id              = "subnet-8e0e9fe5"

  provisioner "file" {
    source      = "~/.aws/credentials"
    destination = "~/.aws/credentials"
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("~/My_key.pem") 
  }
  

  provisioner "file" {
    source      = "~/.aws/config"
    destination = "~/.aws/config"
  }
  
  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo yum update -y
  sudo yum install apache2 -y
  echo "*** Completed Installing apache2
  EOF

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}