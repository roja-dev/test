provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules-vpc"

  vpc_name            = var.vpc_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = [for az in var.availability_zones : "${var.aws_region}${az}"]
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  tags                 = var.tags
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Security group for EC2 instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_instance" "ec2_instance" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnet_ids[count.index % length(module.vpc.public_subnet_ids)]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name              = var.key_name

  tags = merge(
    var.tags,
    {
      Name = "ec2-instance-${count.index + 1}"
    }
  )
}
