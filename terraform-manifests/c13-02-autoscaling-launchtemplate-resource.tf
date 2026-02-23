# INFO: AWS Launch Template
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template

resource "aws_launch_template" "my_launch_template" {
  name_prefix   = "${local.name}-"
  description   = "My Launch Template"
  image_id      = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type_private

  vpc_security_group_ids = [ # NOTE: Attach INGRESS SG

    aws_security_group.private-web-8080.id,
    aws_security_group.private-egress.id # NOTE: Attach EGRESS SG

  ]

  user_data = filebase64("${path.module}/app1-install.sh")

  ebs_optimized = true
  //default_version        = 1.0
  update_default_version = true # NOTE: When changes are made to the template, it will associate the new version with ASG

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 10
      delete_on_termination = true
      volume_type           = "gp2" # NOTE: Default is gp2
    }
  }

  monitoring {
    enabled = true
  }

  # INFO: Attach IAM Instance Profiles (EC2 instances cannot use IAM roles directly — they must use an instance profile)

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile_jvx.name # NOTE: Instance profile Roles and Policies (c14-03-iam-instance-profile-jvx.tf)
  }

  # INFO: Tag specifications for instances launched from this template
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${local.name}-launchtemplate"
      owners      = local.owners
      environment = local.environment
    }
  }

  # INFO: Tag specifications for the launch template itself
  tags = {
    Name        = "${local.name}"
    owners      = local.owners
    environment = local.environment
  }

}