provider "aws" {
  region     = "us-east-1"
}

module "vpc" {
  source = "./vpc"
}

module "elastic" {
  source     = "./elastic"
  dmz_subnet = "${module.vpc.subnet_id}"
  els_sg     = "${module.vpc.sg_id}"
}
