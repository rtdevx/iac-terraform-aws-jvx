# INFO: Enable SSM for managing EC2 instances
# ? https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html

# INFO: Create SSM IAM Role
resource "aws_iam_role" "ec2_ssm_role" {
  name = "iac-aws-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# INFO: Create and attach SSM IAM Policy
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# INFO: Create IAM Instance profile
resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "iac-aws-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

# NOTE: `iam_instance_profile` is attached to a launchtemplate to be effective

# INFO: Restrict SSM access to Administrators only

