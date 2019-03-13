# Cypress on AWS Lambda

The first step is getting a single cypress spec running on Amazon Linux.

Couldn'ta done this without https://github.com/dimkir/nightmare-lambda-tutorial.

## First install dependencies

We copy the general approach from https://gist.github.com/dimkir/f4afde77366ff041b66d2252b45a13db but with docker locally, to get all the stuff pretty much working INSIDE the container. We use https://github.com/lambci/docker-lambda cause it replicates the live AWS env. IIRC even sam-local uses it.

We need xvfb and some other stuff.

```
docker build . -t cypress-lambda
```

Now we have a container that has all the dependencies in it. Just to test and see that we can run that single spec: 

```
$ time docker run --name cypress-lambda cypress-lambda

      Spec                                    Tests  Pass…  Fail…  Pend…  Skip…
  ┌────────────────────────────────────────────────────────────────────────────┐
  │ ✔ sample_spec.js                  00:04      1      1      -      -      - │
  └────────────────────────────────────────────────────────────────────────────┘
    All specs passed!                 00:04      1      1      -      -      -


real    0m19.701s
user    0m0.033s
sys     0m0.051s
```


## Extract dependencies from container

Having just executed the container, and having given it a name, we can `docker cp` and snag things from within it:

- `node_modules`
- `/usr/local/lib`
- Xvfb...

Run:

```
./deps.sh
```

To do that.

## Invoke Lambda handler locally

We need to get those things IN there now and execute invoke the handler:

```
docker run --rm -v "$PWD":/var/task lambci/lambda:nodejs8.10
```
