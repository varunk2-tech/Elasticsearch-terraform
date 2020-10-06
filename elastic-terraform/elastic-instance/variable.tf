variable "ami_id" {
  default = "ami-0235d82964eb58da6"
}

variable "instance_type" {
  default = "t2.nano"
}


variable "availability-zones" {
  default = "us-east-1a"
}

variable "dmz_subnet" {
  default = ""
}

variable "els_sg" {
  default = ""
}
