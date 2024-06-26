terraform {
  
#   terraform version at the time of writing this post 
required_version = ">= 0.12.24"

backend "s3" {
  bucket = "cloudquickpocsbackendtf"
  key = "quickcloudpocsbackend.tfstate"
  region = "us-east-1"
}
}

provider "random" {
  
}

provider "aws" {
  region = "us-east-1"
}

# provider us-west-1

provider "aws" {
  alias ="central"
  region = "us-west-1"
}