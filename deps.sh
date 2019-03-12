#!/bin/bash

echo 'attempting to remove cypress-lambda container...'
docker rm cypress-lambda

echo 'running cypress-lambda container for a sec...'
docker run --name cypress-lambda cypress-lambda sleep 1

mkdir -p ./lib

echo 'schlepping /usr/lib64, just what Xvfb depends on...'
docker run -it cypress-lambda bash -c  'ldd /usr/bin/Xvfb' \
  | grep /usr/lib64 | cut -d" " -f 3 | tr -d '\r' \
  | xargs -I{} docker cp -L cypress-lambda:{} ./lib
rm lambci.txt cypress-lambda.txt

echo 'and node modules and xvfb...'
docker cp -L cypress-lambda:/app/node_modules .
docker cp -L cypress-lambda:/usr/bin/Xvfb .


echo 'done'
