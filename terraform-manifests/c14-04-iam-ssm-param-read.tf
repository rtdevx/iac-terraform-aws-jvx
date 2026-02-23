# INFO: Allow EC2 instance SSM Parameter read

data "aws_caller_identity" "current" {} # NOTE: Query aws for current caller identity

# INFO: Create IAM Policy AND attach to a role
resource "aws_iam_role_policy" "ssm_param_read" {
  name = "ec2-ssm-param-read-policy"
  role = aws_iam_role.ec2_instance_profile_jvx.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # --- SSM Parameter Read ---
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/jvx/*" # ? Who is the caller in GH actions scenario? EC2 instance or GitHub?
      }
    ]
  })
}