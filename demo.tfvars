cidr        = "10.1.0.0/16"
envname     = "dev"
pubsubnets  = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
privsubnets = ["10.1.3.0/24", "10.1.4.0/24", "10.1.5.0/24"]
datasubnets = ["10.1.6.0/24", "10.1.7.0/24", "10.1.8.0/24"]
azs         = ["us-east-1a", "us-east-1b", "us-east-1c"] 
region = "us-east-1"
profile = "test"

ami         = "ami-0889a44b331db0194"
type        = "t2.micro"