+++
date = "2017-06-22T21:21:49+05:30"
title = "Everything U need to know about Kompose-II"
category = "Blog"
author = "Suraj Narwade"
menu = "main"
+++
 
 
In this part, we will talk about Build and push support for kompose as well as docker-compose v3 support, some docker-compose doesn’t contain `image` key, that means docker-compose file is in code repository and when we do, `docker-compose build` or `docker-compose up`, it is supposed to build docker image as instead `build` key is provided.
 
Until 0.1.0 release, support for `build` key was limited in kompose. Going into detail,
`build` wasn’t supported for kubernetes provider.
 
```
$ kompose convert
WARN Kubernetes provider doesn't support build key - ignoring 
INFO file "foo-service.yaml" created
INFO file "foo-deployment.yaml" created 
```
Whereas in case of openshift provider, buildconfig is used to generate
```
$ kompose convert --provider=openshift
INFO Buildconfig using git@github.com:surajnarwade/kompose.git::master as source. 
INFO file "foo-service.yaml" created 
INFO file "foo-deploymentconfig.yaml" created 
INFO file "foo-imagestream.yaml" created 
INFO file "foo-buildconfig.yaml" created 
```
 
But now, its supported :)
When you do `kompose up`, respective docker image will be created and pushed to respective docker registry for which credentials are stored in `~/.docker/config.json` in user’s home directory.
 
For example,
Docker compose file is:
 
```
version: "2"
 
services:
    foo:
        build: "./build"
        image: docker.io/surajnarwade/foobar
```
When we want to deploy it,
 
```
$ kompose up
INFO Build key detected. Attempting to build and push image 'docker.io/surajnarwade/foobar' 
INFO Building image 'docker.io/surajnarwade/foobar' from directory 'build' 
INFO Image 'docker.io/surajnarwade/foobar' from directory 'build' built successfully 
INFO Pushing image 'surajnarwade/foobar:latest' to registry 'docker.io' 
INFO Attempting authentication credentials 'https://index.docker.io/v1/ 
INFO Successfully pushed image 'surajnarwade/foobar:latest' to registry 'docker.io' 
INFO We are going to create Kubernetes Deployments, Services and PersistentVolumeClaims for your Dockerized application. If you need a different kind of resources, use the 'kompose convert' and 'kubectl create -f' commands instead. 
 
INFO Deploying application in "default" namespace 
INFO Successfully created Service: foo
INFO Successfully created Deployment: foo
 
Your application has been deployed to Kubernetes. You can run 'kubectl get deployment,svc,pods,pvc' for details.
```
Note: if you are trying it on, minishift, don’t forget to login before kompose up, unless it will throw an error like:
 
```
FATA Error while deploying application: the server has asked for the client to provide credentials
```
 
If you already built and pushed image, then you can use the following command to disable building and pushing docker images
 
```
$ kompose up --build none
```
 
Docker compose v3 support:
 
Before his, kompose was supporting Docker compose v1 and v2.
 
But now we can convert docker compose v3 files into kubernetes/openshift manifests as easy as before.
 
We will see example,
 
```
version: "3"
 
services:
 
  redis-master:
    image: gcr.io/google_containers/redis:e2e 
    ports:
      - "6379"
 
  redis-slave:
    image: gcr.io/google_samples/gb-redisslave:v1
    ports:
      - "6379"
    environment:
      - GET_HOSTS_FROM=dns
 
  frontend:
    image: gcr.io/google-samples/gb-frontend:v4
    ports:
      - 80:80
    environment:
      - GET_HOSTS_FROM=dns
    labels:
      - "kompose.service.type=nodeport"
```
 
Along with v3 support, we have added more key support which were not in compose v3
Such as replicas, restart_policy etc.
 
 
 
 
 

