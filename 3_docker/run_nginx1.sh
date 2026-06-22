#!/bin/bash
set -x
docker run -d --name web_server -p80:80 -v $PWD/html:/usr/share/nginx/html nginx
