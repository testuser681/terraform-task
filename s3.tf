resource "aws_s3_bucket" "private_bucket_corgi" {
  bucket = "private-bucket-corgi"
  acl    = "private"

  tags = {
    Name        = "Private bucket"
    Environment = "Dev"
  }
}