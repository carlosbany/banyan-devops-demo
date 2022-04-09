locals {
  tags = merge(var.tags, {
    Provider = "Banyan"
    Name = "${var.name_prefix}-connector"
  })
}

data "aws_ami" "ubuntu" {
  most_recent = true


  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "sg" {
  name        = "${var.name_prefix}-connector-sg"
  description = "Connector engress traffic (no ingress needed)"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, var.security_group_tags)

  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = var.management_cidrs
    description       = "SSH"
  }

  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]    
    description       = "Banyan Global Edge network"
  }
}

resource "aws_instance" "conn" {
  ami             = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = var.ssh_key_name

  tags = local.tags
  
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = var.subnet_id
  associate_public_ip_address = true

  monitoring      = true
  ebs_optimized   = true

  ephemeral_block_device {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  metadata_options {
    http_endpoint               = var.http_endpoint_imds_v2
    http_tokens                 = var.http_tokens_imds_v2
    http_put_response_hop_limit = var.http_hop_limit_imds_v2
  }

  user_data = join("", concat([
    "#!/bin/bash -ex\n",
    # use the latest, or set the specific version
    "VER=$(curl -sI https://www.banyanops.com/netting/connector/latest | awk '/Location:/ {print $2}' | grep -Po '(?<=connector-)\\S+(?=.tar.gz)')\n",
    var.package_version != null ? "VER=${var.package_version}\n": "",
    # create folder for the Tarball
    "mkdir -p /opt/banyan-packages\n",
    "cd /opt/banyan-packages\n",
    # download and unzip the files
    "wget https://www.banyanops.com/netting/connector-$VER.tar.gz\n",
    "tar zxf connector-$VER.tar.gz\n",
    "cd connector-$VER\n",
    # create the config file
    "echo 'command_center_url: ${var.command_center_url}' > connector-config.yaml\n",
    "echo 'api_key_secret: ${var.api_key_secret}' >> connector-config.yaml\n",
    "echo 'connector_name: ${var.connector_name}' >> connector-config.yaml\n",
    "./setup-connector.sh\n",
    "journalctl --no-pager -u connector.service\n",
    ], var.custom_user_data))
}