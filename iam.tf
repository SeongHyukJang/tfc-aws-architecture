resource "aws_iam_policy" "policy" {
  name = "70491-log-bucket-policy"
  description = "policy for s3 bucket"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.log_bucket.arn}"
    }

  ]
}
EOT
}

resource "aws_iam_instance_profile" "ec2_iam_profile" {
    name = "70491_iam_profile"
    role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
    name = "70491_ec2_role"
    description = "role for EC2"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_role" {
  name = "70491_lambda_role"
  description = "role for Lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_role_attach" {
    role = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_role_attach" {
    role = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_role_attach" {
    role = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_role_attach" {
    role = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}