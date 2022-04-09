#!/bin/bash
echo "let name = \"$HOSTNAME\";" > /html/env.js
echo "document.write(name);" >> /html/env.js
docker run -v /html:/usr/share/nginx/html:ro -p 80:80 nginx:1.20.2