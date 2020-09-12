##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  version = "~>2.0"
  profile = "deep-dive"
  region     = var.region
}

locals {
  common_tags = {}
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.44.0"

  name = "web-vpc"

  cidr = var.web_cidr_block
  azs = slice(data.aws_availability_zones.available.names, 0, var.web_subnet_count)
  # private_subnets = var.web_private_subnets
  public_subnets = var.web_public_subnets

  enable_nat_gateway = false

  create_database_subnet_group = false

  tags = {
    Environment = "Production"
    Team = "Network"
  }
}

# INSTANCES #
resource "aws_instance" "nginx1" {
  ami                    = data.aws_ami.aws_linux.id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.webapp_http_inbound_sg.id,
                            aws_security_group.webapp_outbound_sg.id,
                            aws_security_group.webapp_ssh_inbound_sg.id]
  key_name               = var.key_name

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)

  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start",
      "echo '<html><head><title>Blue Team Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">Blue Team</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html"
    ]
  }
}