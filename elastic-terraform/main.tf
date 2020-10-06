provider "aws" {
  region     = "us-east-1"
}

module "vpc" {
  source = "./vpc"
}

module "elastic-instance" {
  source     = "./elastic-instance"
  dmz_subnet = "${module.vpc.subnet_id}"
  els_sg     = "${module.vpc.sg_id}"
}
