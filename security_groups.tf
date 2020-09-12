##################################################################################
# RESOURCES
##################################################################################

resource "aws_security_group" "webapp_http_inbound_sg" {
  name        = "demo_webapp_http_inbound"
  description = "Allow HTTP from Anywhere"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "terraform_demo_webapp_http_inbound"
  }
}

resource "aws_security_group" "webapp_ssh_inbound_sg" {
  name        = "demo_webapp_ssh_inbound"
  description = "Allow SSH from certain ranges"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  vpc_id = module.vpc.vpc_id

  tags = merge(local.common_tags,{
    Name = "terraform_demo_webapp_ssh_inbound"
  })
}

resource "aws_security_group" "webapp_outbound_sg" {
  name        = "demo_webapp_outbound"
  description = "Allow outbound connections"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = module.vpc.vpc_id

  tags = merge(local.common_tags,{
    Name = "terraform_demo_webapp_outbound"
  })
}
