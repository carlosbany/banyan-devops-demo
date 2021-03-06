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
  subnet_id = module.foundation_layer.aws_subnet_private_id
  key_name = local.ec2_keypair
  tags = {
    Name = "${local.name}-instance"
  }
  user_data = join("", concat([
    "#!/bin/bash -ex\n",
    "sudo apt update -y\n",
    "sudo apt install -y ca-certificates curl gnupg lsb-release\n",
    "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg\n",
    "sudo echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null\n",
    "sudo apt update -y\n",
    "sudo apt install -y docker-ce docker-ce-cli containerd.io \n",
    "sudo systemctl enable docker.service\n",
    "sudo systemctl enable containerd.service\n",
    "INSTANCE_ID=\"${local.name}\"\n",
    "export PRIVATE_IP=\"$(hostname -i | awk '{print $3}')\"\n",
    "docker run -e INSTANCE_ID -e PRIVATE_IP -p 80:80 gcr.io/banyan-pub/demo-site\n"
  ]))
  vpc_security_group_ids = [module.foundation_layer.connector_sg]
}