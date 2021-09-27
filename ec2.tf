data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_launch_configuration" "corgi_config" {
  name                   = "corgi-config"
  image_id               = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  key_name               = "My_key"
  enable_monitoring      = true
  security_groups        = ["sg-0b5469383489061bf"]
  iam_instance_profile   = aws_iam_instance_profile.s3_profile.name
  
  user_data = <<-EOF
  #!/bin/bash
  sudo su
  yum update -y
  yum -y install httpd
  systemctl start httpd.service
  systemctl enable httpd.service
  aws s3 cp s3://private-bucket-corgi/corgi.html /var/www/html/index.html
  EOF
}

resource "aws_autoscaling_group" "corgi_scaling" {
  name                 = "corgi-scale"
  launch_configuration = aws_launch_configuration.corgi_config.name
  min_size             = 1
  max_size             = 3
  availability_zones   = ["us-east-2a"]
}