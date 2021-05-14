
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
    required_version = "~> 0.14"
  backend "remote" {
    hostname      = "app.terraform.io"
    organization  = "example-org-4f064f"

    workspaces {
      name = "state-migration"
    }
  }
}


module "apache-us-east-1" {
  source        = "./apache"
  region        = "us-east-1"
  instance_type = "t2.micro"
  #ami= "ami-0742b4e673072066f"
  ami = "ami-0d5eff06f840b45e9"
}

#module "apache-us-west-1" {
 # source = "./apache"
  #region = "us-west-1"
  #ami = "ami-0577b787189839998"
#}