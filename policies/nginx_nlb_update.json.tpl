{

    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "ELB",
        "Action": [
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DeregisterTargets"
        ],
        "Effect": "Allow",
        "Resource": "*"
      },
      {
        "Sid": "CW",
        "Action": [
          "cloudwatch:putMetricData"
        ],
        "Effect": "Allow",
        "Resource": "*"
      },
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
                "s3:GetObject",
                "s3:List*",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::cv-${env}-lambda/*",
                "arn:aws:s3:::cv-${env}-lambda",
                "arn:aws:s3:::cv-${env}-nginx-nlb-proxy/*",
                "arn:aws:s3:::cv-${env}-nginx-nlb-proxy"
            ]
      }
    ]
  }
