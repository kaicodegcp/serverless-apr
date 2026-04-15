# Wrapper: mws-vpc-endpoint
module "mws_vpc_endpoint" {
  source = "../../modules/mws-vpc-endpoint"

  account_id = var.account_id
  vpc_endpoint_name = var.vpc_endpoint_name
  region = var.region
  aws_vpc_endpoint_id = var.aws_vpc_endpoint_id
  aws_account_id = var.aws_account_id
}
