# INFO: Environment specific variables

# INFO: AWS Region and Account
aws_region     = "eu-west-2"
aws_account_id = "390157243794"

# INFO: Environment
environment = "stag"

# INFO: VPC Variables
vpc_name = "myvpc"
vpc_cidr = "10.0.0.0/16"

# INFO: EC2 Instance Variables
instance_type_private = "t3.nano"
//private_instance_count = 2 # NOTE: Probably not needed as ASG will manage this.

# INFO: DNS Name
dns_name = "stag.aws.skynetx.uk"