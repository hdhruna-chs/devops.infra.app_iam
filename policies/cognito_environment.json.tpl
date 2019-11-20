{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:us-east-1:${account}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:s3:::cv-${env}-authorizer/*",
                "arn:aws:logs:us-east-1:${account}:log-group:/aws/lambda/${env}_lambda_authorizer:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:*"
            ],
            "Resource": [
                "arn:aws:dynamodb:us-east-1:${account}:table/AppEnvironmentConfig-${env}"
            ]
        }
    ]
}
