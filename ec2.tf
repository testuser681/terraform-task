resource "aws_launch_configuration" "corgi_config" {
  name                   = "corgi-config"
  image_id               = "ami-00dfe2c7ce89a450b"
  instance_type          = "t2.micro"
  key_name               = "My_key"
  enable_monitoring      = true
  security_groups        = ["sg-0b5469383489061bf"]
  iam_instance_profile   = aws_iam_role.read_s3_role.name
  
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