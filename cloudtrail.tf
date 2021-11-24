resource "aws_cloudtrail" "cloudtrail" {
    name =  "${var.stack}-cloudtrail-2021"
    s3_bucket_name = aws_s3_bucket.cloudfrontbucket.id
    s3_key_prefix = "prefix"
    include_global_service_events = true
    is_multi_region_trail =  true
}

resource "aws_s3_bucket" "cloudfrontbucket" {
    bucket = "${var.stack}-cloudtrail-2021"
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
    }
    }
}
    lifecycle_rule {
        id = "remove_old_logs"
        enabled = true
        prefix = "AWSLogs/${data.aws_caller_identity.current.account_id}/CloudTrail/"
        expiration {
            days = 30
        }
    }
}

resource "aws_s3_bucket_policy" "s3cloudfrontpolicy" {
    bucket = aws_s3_bucket.cloudfrontbucket.id
    policy = jsonencode(
{
    Version = "2012-10-17"
    Statement = [
        {
            Sid = "AWSCloudTrailAclCheck"
            Effect = "Allow"
            Principal = {
            AWS = "*"
        }
            Action = "s3:GetBucketAcl"
            Resource = "${aws_s3_bucket.cloudfrontbucket.arn}"
        },
        {
            Sid =  "AWSCloudTrailWrite"
            Effect = "Allow"
            Principal = {
            Service = "cloudtrail.amazonaws.com"
            }
            Action = "s3:PutObject"
            Resource = "${aws_s3_bucket.cloudfrontbucket.arn}/*"
            Condition = {
                StringEquals = {
                    "s3:x-amz-acl" = "bucket-owner-full-control"
                }
            }
        }
    ]
})
}