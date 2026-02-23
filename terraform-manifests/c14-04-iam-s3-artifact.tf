# INFO: Allow EC2 instance accessing S3 artifact bucket
# ? https://repost.aws/knowledge-center/ec2-instance-access-s3-bucket

# INFO: Create IAM Policy AND attach to "ec2_instance_profile_jvx" role
resource "aws_iam_role_policy" "s3_artifact" {
  name = "ec2-s3-artifact-access-policy"
  role = aws_iam_role.ec2_instance_profile_jvx.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # --- S3 Read Access ---
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_artifact}",
          "arn:aws:s3:::${var.s3_artifact}/*"
        ]
      }
    ]
  })
}