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
  instance_type          = var.default_instance
  key_name               = var.default_key
  enable_monitoring      = true
  security_groups        = [aws_security_group.allow_http_ssh.id]
  iam_instance_profile   = aws_iam_instance_profile.s3_profile.name
  
  user_data = base64encode(data.template_file.user_data.rendered)
}

resource "aws_autoscaling_group" "corgi_scaling" {
  name                 = "corgi-scale"
  launch_configuration = aws_launch_configuration.corgi_config.name
  min_size             = 1
  max_size             = 3
  availability_zones   = [var.default_az]
}