#!/bin/bash

docker run -v /html:/usr/share/nginx/html:ro -p 80:80 nginx:1.20.2