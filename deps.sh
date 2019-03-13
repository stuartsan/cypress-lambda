#!/bin/bash

echo 'attempting to remove cypress-lambda container...'
docker rm cypress-lambda

echo 'running cypress-lambda container for a sec...'
docker run --name cypress-lambda cypress-lambda sleep 1

mkdir -p ./lib

echo 'schlepping Xvfb’s dependencies...'
docker run -it cypress-lambda bash -c  'ldd /usr/bin/Xvfb' \
  | cut -d" " -f 3 | tr -d '\r' \
  | xargs -I{} docker cp -L cypress-lambda:{} ./lib

echo 'and Cypress’s dependencies...'
docker run -it cypress-lambda bash -c  'ldd /root/.cache/Cypress/3.1.5/Cypress/Cypress' \
  | cut -d" " -f 3 | tr -d '\r' \
  | xargs -I{} docker cp -L cypress-lambda:{} ./lib

echo 'and node modules and Xvfb...'
docker cp -L cypress-lambda:/app/node_modules .
docker cp -L cypress-lambda:/usr/bin/Xvfb .

echo 'and xkb...'
docker cp -L cypress-lambda:/usr/share/X11/xkb ./lib
docker cp  cypress-lambda:/app/default.xkm .

# https://unix.stackexchange.com/a/315172
# you gotta see it to believe it
echo 'patching Xvfb binary, yolo...'
position=$(strings -t d Xvfb | grep xkbcomp | grep xkm | cut -d' ' -f1)
# this string is padded so that it matches the same length of the string above
echo -n 'R="%X%X%d%X%X%X%X%X%X" /bin/cp /var/task/default.xkm /tmp/%s.xkm   ' | dd bs=1 of=Xvfb seek="$position" conv=notrunc

echo 'and finally, the cypress binary...'
docker cp -L cypress-lambda:/root/.cache/Cypress/3.1.5/Cypress/ ./tmp
cp -R tmp/* lib/
rm -rf tmp


echo 'done'
