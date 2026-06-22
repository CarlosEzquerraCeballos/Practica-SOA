#!/bin/bash
set -x
docker run -d --name web_server3 --net=host -v $PWD/html:/usr/share/nginx/html nginx
