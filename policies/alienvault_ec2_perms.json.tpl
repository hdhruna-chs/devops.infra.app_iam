{
              "Version": "2012-10-17",
              "Statement": [
                {
                  "Action": [
                    "guardduty:Get*",
                    "guardduty:List*",
                    "cloudtrail:Describe*",
                    "cloudtrail:Get*",
                    "cloudtrail:List*",
                    "cloudwatch:Describe*",
                    "cloudwatch:Get*",
                    "cloudwatch:List*",
                    "ec2:Describe*",
                    "elasticloadbalancing:Describe*",
                    "iam:List*",
                    "iam:Get*",
                    "route53:Get*",
                    "route53:List*",
                    "rds:Describe*",
                    "s3:Get*",
                    "s3:List*",
                    "sdb:GetAttributes",
                    "sdb:List*",
                    "sdb:Select*",
                    "ses:Get*",
                    "ses:List*",
                    "sns:Get*",
                    "sns:List*",
                    "sqs:GetQueueAttributes",
                    "sqs:ListQueues",
                    "sqs:ReceiveMessage"
                  ],
                  "Effect": "Allow",
                  "Resource": "*"
                },
                {
                  "Effect": "Allow",
                  "Action": "cloudtrail:*",
                  "Resource": "*"
                },
                {
                  "Action": [
                    "logs:Describe*",
                    "logs:Get*",
                    "logs:TestMetricFilter"
                  ],
                  "Effect": "Allow",
                  "Resource": "*"
                }
              ]
            }