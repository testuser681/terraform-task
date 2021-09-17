resource "aws_s3_bucket" "private_bucket_corgi" {
  bucket = "private-bucket-corgi"
  acl    = "private"

  tags = {
    Name        = "Private bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_object" "corgi" {
  bucket = aws_s3_bucket.private_bucket_corgi.id
  key    = "profile"
  acl    = "private"
  source = "./corgi.html"
  etag = filemd5("./corgi.html")

}