# INFO: Enable SSM for managing EC2 instances
# ? https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html

# INFO: Create SSM IAM Role for Instance Profile
resource "aws_iam_role" "ec2_instance_profile_jvx" {
  name = "iac-aws-ec2-instance-profile-jvx-role"

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

# INFO: Attach IAM SSM Policy to SSM IAM Role to allow SSM Managing EC2 instances
resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.ec2_instance_profile_jvx.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# INFO: Create IAM Instance profile (EC2 instances cannot use IAM roles directly — they must use an instance profile)
resource "aws_iam_instance_profile" "ec2_instance_profile_jvx" {
  name = "iac-aws-ec2-instance-profile-jvx"
  role = aws_iam_role.ec2_instance_profile_jvx.name
}

# NOTE: `iam_instance_profile` must be attached to a launchtemplate to be effective