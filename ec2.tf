module "aws_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "linux-instance"

  ami                    = "ami-00dfe2c7ce89a450b"
  instance_type          = "t2.micro"
  key_name               = "My_key"
  monitoring             = true
  vpc_security_group_ids = ["sg-0856c1a7968986b0f"]
  subnet_id              = "subnet-8e0e9fe5"

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2
  BUCKET_URL="private-bucket-corgi.s3-website.us-east-2.amazonaws.com"
  s3 cp s3://private-bucket-corgi/ /home/ec2-user/ --recursive"
  EOF

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}