# INFO: Allow EC2 instance Read Secret
/**
Required for 
**/

data "aws_caller_identity" "current" {} # NOTE: Query aws for current caller identity

# INFO: Create IAM Policy AND attach to a role
resource "aws_iam_role_policy" "ssm_secret_read" {
  name = "ec2-ssm-secret-read-policy"
  role = aws_iam_role.ec2_instance_profile_jvx.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # --- SSM Secret Read ---
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "*" # ? Who is the caller in GH actions scenario? EC2 instance or GitHub?
      }
    ]
  })
}