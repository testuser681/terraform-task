data "aws_iam_policy_document" "read_s3_policy" {
  statement {
      actions = ["s3:Get*", "s3:List*"]
      resources = ["arn:aws:s3:::private-bucket-corgi/*"]
  }
} 

resource "aws_iam_role" "read_s3_role" {
  name = "read-s3-role"
  permissions_boundary = "arn:aws:iam::113304117666:policy/DefaultBoundaryPolicy"
  assume_role_policy = data.aws_iam_policy_document.read_s3_policy.json
}