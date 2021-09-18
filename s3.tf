provider "aws" {
  profile = "default"
  region = "us-east-2"
}

resource "aws_s3_bucket" "private_bucket_corgi" {
  bucket = "private-bucket-corgi"
  acl    = "private"

  tags = {
    Name        = "Private bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_object" "corgi" {
  for_each = fileset(".", "corgi.html")
  bucket = aws_s3_bucket.private_bucket_corgi.id
  key    = each.value
  acl    = "private"
  source = "./${each.value}"
  etag = filemd5("./${each.value}")

}