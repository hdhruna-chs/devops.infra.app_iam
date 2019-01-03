{

    "Version": "2012-10-17",
    "Statement": [
        {
          "Sid": "CloudWatchLogs",
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Effect": "Allow",
          "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::cv-${env}-lambda/*",
                "arn:aws:s3:::cv-${env}-lambda",
                "arn:aws:s3:::cv-${env}-consul/*",
                "arn:aws:s3:::cv-${env}-consul"
            ]
        }
    ]
  }
