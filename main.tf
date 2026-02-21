

module "vpc" {
  source             = "./modules/vpc"
  aws_region         = var.aws_region
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
  route_cidr_block   = var.route_cidr_block
}


module "ec2" {
  source        = "./modules/ec2"
  subnet_id     = module.vpc.public_subnet_id
  instance_type = var.instance_type
  vpc_id        = module.vpc.vpc_id
}














