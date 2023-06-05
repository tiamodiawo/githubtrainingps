#test##
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.29.0"
    }
  }

  backend "s3" {
        bucket  = "demo-123458-tf"
        dynamodb_table = "demo-123458-tf-dynamodb"
        encrypt = true
        key     = "platform.tfstate"
        region  = "eu-west-1"
        profile = "692798042113_SWAdministratorAccess"
    }
}

provider "aws" {
  region = "eu-west-1"
}

# ================== AMI ==================
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  tags = {
    Name = "${terraform.workspace}-ami"
  }
}

# ====================== EC2 INSTANCE ===================
resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.latest-amazon-linux-image.id
  instance_type = "t2.micro"
  subnet_id     = "subnet-0298f1a0df96258d5"
  
  tags = {
    Name = "ec2-deploy"
  }
}
