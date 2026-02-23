# INFO: Environment specific variables

# INFO: Environment
environment = "prod"

# INFO: VPC Variables
vpc_name = "myvpc"
vpc_cidr = "10.0.0.0/16"

# INFO: EC2 Instance Variables
instance_type_private = "t3.nano"
//private_instance_count = 2 # NOTE: Probably not needed as ASG will manage this.

# INFO: DNS Name
dns_name = "www.aws.skynetx.uk"