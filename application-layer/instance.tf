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

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = var.subnet
  key_name = var.key_pair_id

  tags = {
    Name = "${var.name}-instance"
  }

  user_data = join("", concat([
    "#!/bin/bash -ex\n",
    "curl -L https://github.com/banyansecurity/banyan-devops-demo/releases/download/v0.16/release.tar.gz > release.tar.gz\n",
    "sudo tar -xzvf release.tar.gz\n",
    "sudo sh demo-site/docker-run.sh\n"
  ]))

  vpc_security_group_ids = [aws_security_group.allow-connector.id]
}