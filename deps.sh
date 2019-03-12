echo 'attempting to remove cypress-lambda container...'
docker rm cypress-lambda
echo 'running cypress-lambda container for a sec...'
docker run --name cypress-lambda cypress-lambda sleep 1
echo 'schlepping deps from inside container to host...'
docker cp cypress-lambda:/usr/local/lib .
docker cp cypress-lambda:/app/node_modules .
docker cp cypress-lambda:/usr/bin/Xvfb .
echo 'python was already there, removing it...'
rm -rf lib/python*
echo 'done'
