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
                "cloudwatch:PutMetricData"
            ],
            "Resource": "*"
        },
        {
        "Sid": "Stmt1572889115514",
        "Action": [
            "ecs:Describe*"
        ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
        "Sid": "Stmt1572890032797",
        "Action": [
            "autoscaling:Describe*"
        ],
        "Effect": "Allow",
        "Resource": "*"
        },
        {
        "Sid": "Stmt1572890112427",
        "Action": [
            "ecs:Describe*",
            "ecs:List*"
        ],
        "Effect": "Allow",
        "Resource": "*"
        }
    ]
  }
