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
            "Resource": "*"
        }
    ]
  }
