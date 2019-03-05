{

    "Version": "2012-10-17",
    "Statement": [
        {
          "Sid": "CloudWatchLogs",
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DeleteLogGroup"
          ],
          "Effect": "Allow",
          "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:Get*",
                "s3:List*",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::cv-${env}-lambda/*",
                "arn:aws:s3:::cv-${env}-lambda"
            ]
        },
        {
          "Effect": "Allow",
          "Action" : [
              "ec2:CreateImage",
              "ec2:CreateTags",
              "ec2:DeleteSnapshot",
              "ec2:DeregisterImage",
              "ec2:DescribeImages",
              "ec2:DescribeInstances"
          ],
          "Resource": "*"
        }
    ]
  }
