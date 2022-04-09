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

resource "aws_key_pair" "ssh-key" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = var.subnet
  key_name = aws_key_pair.ssh-key.id

  tags = {
    Name = "${var.name}-instance"
  }

  vpc_security_group_ids = [aws_security_group.allow-connector.id]
}