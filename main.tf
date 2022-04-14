provider "aws" {
region = "ap-south-1"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-backend-spovedd1"
    key    = "state-comm-terraform.tfstate"
    region = "us-east-1"
    dynamodb_table ="lammatha"  
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf-example"
  }
}



resource "aws_instance" "web" {
  ami           = "ami-0d2986f2e8c0f7d01"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.my_subnet.id

  tags = {
    Name = "HelloWorld"
  }
}
