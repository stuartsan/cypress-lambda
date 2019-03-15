# Cypress on AWS Lambda

This repo demonstrates how to jump through a bunch of hoops to run [Cypress](https://cypress.io) on AWS Lambda.

The [blog post, part 1](https://stuartsandine.com/cypress-on-aws-lambda-part-1) contains much more detail.

Right now it only shows how to run a single test; parallelization coming in part 2.

**Requirements**: docker, terraform

The sample e2e test is in `lambda/cypress/integration/sample_spec.js`.


## First build the image to gather dependencies

```
cd lambda
docker build . -t cypress-lambda
```

## Extract dependencies from container

```
./deps.sh
```

## Invoke Lambda handler locally

Verify that the handler invocation works when run locally with 
[docker-lambda](https://github.com/lambci/docker-lambda)'s: nodejs8.10 runtime,
a dockerized replica of the AWS Lambda execution environment:

```
docker run --rm -v "$PWD":/var/task lambci/lambda:nodejs8.10
```

## Deploy it

Back in the project root:

```
touch lambda.zip
terraform init
terraform apply
```
(You'll have to change a couple things in `lambda.tf` for your situation, 
such as the s3 bucket name, which is globally unique)

Now invoke the function via the AWS console, or the CLI, or w/e.

Profit.
