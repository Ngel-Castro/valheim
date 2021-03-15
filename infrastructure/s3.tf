resource "aws_s3_bucket" "valheimBucket" {
  bucket = "valheimBucket" # your user defined bucketName
  acl    = "private"

  tags = {
    Name    = "myProject"
    Project = "myProject"
  }
}

resource "aws_s3_bucket_policy" "valheimBucketPolicy" {
  bucket = aws_s3_bucket.valheimBucket.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "valheimBucketPolicy"
    Statement = [
      {
        Sid       = "valheimBucketPolicy"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.valheimBucket.arn,
          "${aws_s3_bucket.valheimBucket.arn}/*",
        ]
        Condition = {
          StringLike = {
            "aws:userId" = "${aws_iam_role.valheimServerRole.unique_id}/*"
          }
        }
      },
    ]
  })
}