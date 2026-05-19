# INFO: Allow EC2 instance Read Secret
/**
This policy is attached to "ec2_instance_profile_jvx" IAM Role. This role is used for the instance profile that is attached to EC2 instances launched with "aws_launch_template.my_launch_template".

Required to Get Secret from AWS Secrets Manager. Currently used to secure internal traffic coming from Public ALB to EC2 instances with TLS (AWS Secrets Manager stores generated secret to protect java key store).
**/

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
        Resource = [
          aws_secretsmanager_secret.jvx_tls_keystore.arn
        ]
      }
    ]
  })
}