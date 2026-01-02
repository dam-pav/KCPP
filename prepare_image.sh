#!/bin/bash

cd /home/damjan/KCPP   # wherever your repo is
git pull
docker build -t koboldcpp-custom:homoai .