resource "aws_instance" "corginstance" {
  ami                    = "ami-00dfe2c7ce89a450b"
  instance_type          = "t2.micro"
  key_name               = "My_key"
  monitoring             = true
  vpc_security_group_ids = ["sg-0b5469383489061bf"]
  iam_instance_profile   = "S3CorgiRole"

  provisioner "file" {
    source      = "~/.aws/credentials"
    destination = "~/.aws/credentials"
  }

  provisioner "file" {
    source      = "~/.aws/config"
    destination = "~/.aws/config"
  }
  
  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("~/My_key.pem") 
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
    Name        = "corginstance"
  }
}

resource "aws_ami_from_instance" "corgi_ami" {
  name               = "corgi-ami"
  source_instance_id = aws_instance.corginstance.id
}

resource "aws_launch_configuration" "corgi_config" {
  //name          = "corgiguration"
  image_id      = resource.aws_ami_from_instance.corgi_ami.id
  instance_type = "t2.micro"
  key_name               = "My_key"
  iam_instance_profile   = "S3CorgiRole"
}

resource "aws_autoscaling_group" "corgi_scaling" {
  //name                 = "corgi-scale"
  launch_configuration = aws_launch_configuration.corgi_config.name
  min_size             = 1
  max_size             = 3
  availability_zones   = ["us-east-2c"]
}