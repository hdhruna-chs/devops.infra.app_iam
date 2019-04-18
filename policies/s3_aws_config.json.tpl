{
  "Version": "2012-10-17",
  "Statement":
   [

     {
       "Effect": "Allow",
       "Action": ["s3:PutObject"],
       "Resource": [
          "arn:aws:s3:::${bucket_name}/*",
          "arn:aws:s3:::${bucket_name}"
          ],
          "Condition":
             {
               "StringLike":
                 {
                   "s3:x-amz-acl": "bucket-owner-full-control"
                 }
             }
     },
     {
       "Effect": "Allow",
       "Action": ["s3:GetBucketAcl"],
       "Resource": "arn:aws:s3::: ${bucket_name} "
     }
  ]
  }
