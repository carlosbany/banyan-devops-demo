resource "aws_key_pair" "ssh-key" {
  key_name   = local.aws_ssh_key_name
  public_key = local.aws_ssh_key_public_key
}

data "aws_ami" "ubuntu-docker" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu-xenial-docker-stable-latest*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["654814900965"] # Canonical
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu-docker.id
  instance_type = "t3.micro"
  subnet_id = module.foundation_layer.aws_subnet_private_id
  key_name = aws_key_pair.ssh-key.id
  tags = {
    Name = "${local.name}-instance"
  }
  user_data = join("", concat([
    "#!/bin/bash -ex\n",
    "apt update -y\n",
    "sudo apt install -y ca-certificates curl gnupg lsb-release\n",
    "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg\n",
    "sudo echo \\n",
    "sudo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null\"\n",
    "sudo apt update -y\n",
    "sudo apt install -y docker-ce docker-ce-cli containerd.io jq\n",
    "sudo systemctl enable docker.service\n",
    "sudo systemctl enable containerd.service\n",
    "INSTANCE_ID=\"${local.name}\"\n",
    "export PRIVATE_IP=\"$(hostname -i | awk '{print $3}')\"\n",
    "docker run -e INSTANCE_ID -e PRIVATE_IP -p 80:80 gcr.io/banyan-pub/demo-site\n"
  ]))
  vpc_security_group_ids = [aws_security_group.allow-connector.id]
}

resource "aws_security_group" "allow-connector" {
  name        = "${local.name}-connector"
  description = "Allow all traffic from banyan connector"
  vpc_id      = module.foundation_layer.aws_vpc_main_id

  ingress {
    security_groups   = [module.foundation_layer.connector_sg]
    from_port         = 0
    to_port           = 0
    protocol          = "all"
    description       = "allow all from banyan connector"
  }
}