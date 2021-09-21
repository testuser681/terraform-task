resource "aws_instance" "corginstance" {
  ami                    = "ami-00dfe2c7ce89a450b"
  instance_type          = "t2.micro"
  key_name               = "My_key"
  monitoring             = true
  vpc_security_group_ids = ["sg-0b5469383489061bf"]
  iam_instance_profile   = "S3CorgiRole" 
  //subnet_id              = "subnet-8e0e9fe5"

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
  sudo su
  yum update -y
  yum -y install httpd
  systemctl start httpd.service
  systemctl enable httpd.service
  aws s3 cp s3://private-bucket-corgi/corgi.html /var/www/html/index.html
  EOF

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name = "corginstance"
  }
}