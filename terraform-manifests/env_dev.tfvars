# INFO: Environment specific variables

# INFO: AWS Region and Account
aws_region     = "eu-west-2"
aws_account_id = "390157243794"

# INFO: Environment
environment = "dev"

# INFO: VPC Variables
vpc_name = "myvpc"
vpc_cidr = "10.0.0.0/16"

# INFO: EC2 Instance Variables
instance_type_private = "t3.micro"
//private_instance_count = 2 # NOTE: Probably not needed as ASG will manage this.

# INFO: DB Variables
db_name                = "webappdb-dev"

# INFO: DNS Name
dns_name = "dev.aws.skynetx.uk"

