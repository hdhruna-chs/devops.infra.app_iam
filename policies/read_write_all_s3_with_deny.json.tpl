{

    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:Get*",
                "s3:List*",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        }
    ]
  }
