resource "aws_s3_bucket" "awc" {
  bucket = "ldeltoro-awc"
  force_destroy = true
  tags = {
    Name        = "AWC - S3 Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "awc_src_folder" {
  bucket = aws_s3_bucket.awc.bucket
  acl    = "private"

  key = "src/"

  source = "/dev/null"
}

resource "aws_iam_policy" "awc_s3_bucket_rw" {
  name        = "AWCS3BucketRW"
  path        = "/"
  description = "Allows to read and write to AWC bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:AbortMultipartUpload",
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.awc.arn,
          "${aws_s3_bucket.awc.arn}/*"
        ]
      },
    ]
  })
}