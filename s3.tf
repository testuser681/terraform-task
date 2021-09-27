resource "aws_s3_bucket" "private_bucket_corgi" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name        = "Private bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_object" "corgi" {
  for_each = fileset(".", var.html_name)
  bucket = aws_s3_bucket.private_bucket_corgi.id
  key    = each.value
  acl    = "private"
  source = "./${each.value}"
  etag   = filemd5("./${each.value}")

}