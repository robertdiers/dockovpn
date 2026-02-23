#!/usr/bin/env bash

docker build -t mydockovpn .

docker run --cap-add=NET_ADMIN \
-v $PWD/openvpn_data:/opt/dockovpn_data \
-p 1194:1194/udp \
-e HOST_ADDR=localhost \
--rm \
mydockovpn