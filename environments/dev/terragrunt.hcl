locals {
    aws_region = "ap-southeast-1"
    account_id = "928220163045"
}

remote_state {
    backend = "s3"
    config = {
        bucket = "my-terraform-state-wxz"
        key = "dev/terraform.tfstate"
        region = local.aws_region
    }
}

terraform {
    before_hook "copy_modules" {
        commands = ["init","plan","apply"]
        execute = ["cp", "-rf", "${get_repo_root()}/modules","modules"]
    }
    required_providers{
        aws = "~> 5.7.0"
    }
}

generate "common_variables" {
    path = "common_variables.tf"
    if_exists = "overwrite"
    contents = <<EOF

    terraform {
        backend "s3" {}
        required_providers {
            aws = "~> 5.7.0"
        }
    }

    provider "aws" {
        region = "ap-southeast-1"
    }
    EOF
}



