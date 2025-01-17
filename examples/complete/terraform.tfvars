aws_secretsmanager_name = "wayfinder-secrets"
availability_zones      = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
clusterissuer_email     = "my.email@example.com"
disable_internet_access = false
dns_zone_name           = "wf.example.com"
environment             = "prod"
idp_provider            = "generic"
vpc_cidr                = "10.0.0.0/21"
vpc_private_subnets     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
vpc_public_subnets      = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
tags = {
  BusinessCriticality = "High"
  Environment         = "Production"
  Owner               = "SupportTeam"
  Project             = "Operations"
  Repository          = "<Your Repository URL>"
  Provisioner         = "Terraform"
}
