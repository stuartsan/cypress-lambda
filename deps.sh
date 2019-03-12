#!/bin/bash

echo 'attempting to remove cypress-lambda container...'
docker rm cypress-lambda

echo 'running cypress-lambda container for a sec...'
docker run --name cypress-lambda cypress-lambda sleep 1

mkdir -p ./lib

echo 'schlepping /usr/local/lib from inside container to host...'
docker cp -L cypress-lambda:/usr/local/lib ./lib

echo 'and /usr/lib64, just what changed...'
docker run -it lambci/lambda:build-nodejs8.10 bash -c 'find /usr/lib64/ \( -type f -o -type l \) | sort  | xargs -I{} sha512sum {}' > lambci.txt
docker run -it cypress-lambda bash -c 'find /usr/lib64/ \( -type f -o -type l \) | sort  | xargs -I{} sha512sum {}' > cypress-lambda.txt
diff lambci.txt cypress-lambda.txt \
  | grep '^>' | cut -d' ' -f3- | tr -d '\r' \
  | xargs -I{} docker cp -L cypress-lambda:{} ./lib
rm lambci.txt cypress-lambda.txt

echo 'and node modules and xvfb...'
docker cp cypress-lambda:/app/node_modules .
docker cp cypress-lambda:/usr/bin/Xvfb .

echo 'done'
