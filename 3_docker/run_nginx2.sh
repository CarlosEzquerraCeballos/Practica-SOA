#!/bin/bash
set -x
docker run -d --name web_server2 -v $PWD/html:/usr/share/nginx/html nginx
