#!/bin/bash
mv demo-site/html /html
apt update -y
apt install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update -y
apt install -y docker-ce docker-ce-cli containerd.io jq
systemctl enable docker.service
systemctl enable containerd.service
docker pull nginx:1.20.2
export INSTANCE_ID="$(jq '."ds"."dynamic"."instance-identity"."document"."instanceId"' /run/cloud-init/instance-data.json)"
export PRIVATE_IP="$(jq '."ds"."dynamic"."instance-identity"."document"."privateIp"' /run/cloud-init/instance-data.json)"
echo "let name = \"$INSTANCE_ID\";" > /html/env.js
echo "let ipaddress = \"$PRIVATE_IP\";" >> /html/env.js
echo "document.write(name);" >> /html/env.js
echo "document.write(ipaddress);" >> /html/env.js
docker run -v /html:/usr/share/nginx/html:ro -p 80:80 nginx:1.20.2