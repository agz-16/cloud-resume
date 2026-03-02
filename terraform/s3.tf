# S3 Bucket (Imported)
#
# Import commands:
#   terraform import aws_s3_bucket.site agz16cloud-resume-challenge
#   terraform import aws_s3_bucket_public_access_block.site agz16cloud-resume-challenge
#   terraform import aws_s3_bucket_policy.site agz16cloud-resume-challenge

resource "aws_s3_bucket" "site" {
  bucket = "agz16cloud-resume-challenge"
}

# Block Public Access

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#############################################
# Bucket Policy — allow your CloudFront distribution to read from this private bucket

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id

  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.site.arn}/*"
        Condition = {
          ArnLike = {
            "AWS:SourceArn" = "arn:aws:cloudfront::308508691602:distribution/E2515IH3NJYIIN"
          }
        }
      }
    ]
  })
}


# Outputs

output "site_bucket_name" {
  value       = aws_s3_bucket.site.bucket
  description = "S3 bucket name"
}

output "site_bucket_arn" {
  value       = aws_s3_bucket.site.arn
  description = "S3 bucket ARN"
}