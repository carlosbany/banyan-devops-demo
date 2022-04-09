#!/bin/bash
mv demo-site/html /html
apt update -y
apt install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update -y
apt install -y docker-ce docker-ce-cli containerd.io
systemctl enable docker.service
systemctl enable containerd.service
docker pull nginx:1.20.2
echo "let name = \"$HOSTNAME\";" > /html/env.js
echo "document.write(name);" >> /html/env.js
docker run -v /html:/usr/share/nginx/html:ro -p 80:80 nginx:1.20.2