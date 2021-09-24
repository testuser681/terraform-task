resource "aws_iam_policy" "read_s3_policy" {
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": "arn:aws:s3:::private-bucket-corgi/*"
        }
    ]
  }
  EOF
} 

resource "aws_iam_role" "read_s3_role" {
  name = "read-s3-role"
  permissions_boundary = "arn:aws:iam::113304117666:policy/DefaultBoundaryPolicy"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role = aws_iam_role.read_s3_role.name
  policy_arn = aws_iam_policy.read_s3_policy.arn
}

resource "aws_iam_instance_profile" "s3_profile" {
  name = "s3-profile"
  role = aws_iam_role.read_s3_role.name
}