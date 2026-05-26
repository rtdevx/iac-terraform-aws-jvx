# INFO: Restrict SSM access to Administrators AND only in "dev" and "stag" environments (tag)
# ? Sample IAM policies for Session Manager:
# ? https://docs.aws.amazon.com/systems-manager/latest/userguide/getting-started-restrict-access-quickstart.html#restrict-access-quickstart-admin

resource "aws_iam_policy" "ssm_admin_access" {
  name        = "iac-aws-systems-manger-admin-ssm-access"
  description = "Allow administrators to start SSM sessions only on tagged instances"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:StartSession"
        ],
        "Resource" : [
          "arn:aws:ec2:*:${var.aws_account_id}:instance/*" # ?: Hardcoded Account. Should admin group be allowed to run "arn:aws:ssm:" in all regions and only be restricted by "ssm:StartSession" for the specific EC2 instances in the specific account?
        ],
        "Condition" : {
          "StringLike" : {
            "ssm:resourceTag/environment" : [ # NOTE: Only allow ssm access to EC2 instances with specific tags
              "dev",
              "stag"
            ]
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ssmmessages:OpenDataChannel"
        ],
        "Resource" : [
          "arn:aws:ssm:*:*:session/$${aws:userid}-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus",
          "ssm:DescribeInstanceProperties",
          "ec2:DescribeInstances"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:CreateDocument",
          "ssm:UpdateDocument",
          "ssm:GetDocument",
          "ssm:StartSession"
        ],
        "Resource" : "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:document/SSM-SessionManagerRunShell" # ?: Hardcoded Account. Should admin group be allowed to run "arn:aws:ssm:" in all regions and only be restricted by "ssm:StartSession" for the specific EC2 instances in the specific account?
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ssmmessages:OpenDataChannel"
        ],
        "Resource" : [
          "arn:aws:ssm:*:*:session/$${aws:userid}-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:TerminateSession",
          "ssm:ResumeSession"
        ],
        "Resource" : [
          "arn:aws:ssm:*:*:session/$${aws:userid}-*"
        ]
      }
    ]
  })
}

# INFO: Attach "ssm_admin_access" policy to "admin" group in AWS IAM
resource "aws_iam_group_policy_attachment" "admin_ssm_attach" {
  group      = "admin"
  policy_arn = aws_iam_policy.ssm_admin_access.arn
}