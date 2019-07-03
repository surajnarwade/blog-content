+++
date = "2017-06-20T21:21:49+05:30"
title = "Everything U need to know about Kompose-I"
category = "Blog"
author = "Suraj Narwade"
menu = "main"
+++
 

<br>
    Nowadays, Everyone wants to containerize their traditional stack. so people are relying on popular container solutions, like Docker. majorly used for creating, deploying and running applications.
 
### Docker
 
* It has great user experience, one can easily install and get started.
 
### Docker-Compose
 
* We needed something more functional as we need multi container application, Hence docker-compose, where
you define everything regarding how application containers should be built and deployed 
 
* It's good for local development but now we need to get containerized deployment on production 
 
* So we need container orchestration engine:
 
    - Kubernetes/Openshift
    - Docker swarm
    - Mesos
 
### Kubernetes
 
We chose kubernetes due to its robustness and huge contributors and community, hence great support.
 
But kubernetes needs lots of things to learn and manifests files like pods, services, replica sets, deployments, etc
 
 
 
 
### Kompose
 
it is a tool to moves Docker Compose files over to Kubernetes. As most of the developers are already familiar with Docker and Docker compose, hence, with the help of kompose, one can easily convert docker compose files into kubernetes manifests files. 
Kompose was originally started by Skippbox(now it's part of bitnami) and then got contributors from Google and Red Hat and some of other individual contributors. (I am one of the contributors)
 
 
As per title of blog, we will start with how to install `kompose`,
 
#### Installing kompose
 
* Checkout kompose [`release page`](https://github.com/kubernetes-incubator/kompose/releases)
 
* Select binary depending on your distribution
 
* Simply execute the following command
 
```
curl -L https://github.com/kubernetes-incubator/kompose/releases/download/<version>/kompose-<distro> -o kompose && chmod +x kompose && sudo mv kompose /usr/local/bin/
```

**Or**

* For macOS,

```
brew install kompose
```

* For Fedora,

```
sudo dnf -y install kompose
```

* For CentOS,

```
sudo yum -y install kompose
```

* kompose is now ready to use.
 
 <br> 
 
#### Check Kompose version
 
* like any other CLI tools, you can check version by following commands,
 
```
$ kompose version
0.7.0 (HEAD)
```
 
 
<br>
 
#### Autocompletion of commands
 
* is also supported in `bash` and `zsh` shell.
 
```
//for bash shell
$ source <(kompose completion bash)
 
//for zsh shell
$ source <(kompose completion zsh)
```
<br>
 
#### we will explore kompose by using example now.
 
 <br>

* This is guestbook application containing web frontend and redis master (for storage) and redis slave.
 
```
version: "2"
 
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

 <br>

**Note**: *Make sure your kubernetes cluster is up and running before running following example. you can deploy local kubernetes cluster using minikube or minishift.*

<br>

#### Deploying Kubernetes Artifacts Directly
 
* Run `kompose up` to deploy application to kubernetes cluster to test it locally whether on *minishift* or *minikube* or any kind of cluster.
 
```
$ kompose up 
INFO We are going to create Kubernetes Deployments, Services and PersistentVolumeClaims for your Dockerized application. If you need a different kind of resources, use the 'kompose convert' and 'kubectl create -f' commands instead. 
 
INFO Deploying application in "default" namespace 
INFO Successfully created Service: frontend
INFO Successfully created Service: redis-master 
INFO Successfully created Service: redis-slave 
INFO Successfully created Deployment: frontend 
INFO Successfully created Deployment: redis-master 
INFO Successfully created Deployment: redis-slave 
 
Your application has been deployed to Kubernetes. You can run 'kubectl get deployment,svc,pods,pvc' for details.
  
```

<br>
 
#### Generating Kubernetes Artifacts
 
* If you want to store artifacts and use it for future deployments with simple modifications. 
 
* Run `kompose convert` to generate kubernetes manifests.
 
```
$ kompose convert 
INFO Kubernetes file "frontend-service.yaml" created 
INFO Kubernetes file "redis-master-service.yaml" created 
INFO Kubernetes file "redis-slave-service.yaml" created 
INFO Kubernetes file "frontend-deployment.yaml" created 
INFO Kubernetes file "redis-master-deployment.yaml" created 
INFO Kubernetes file "redis-slave-deployment.yaml" created
```

<br>

* which can be deployed with `kubectl create -f`
 
```
$ kubectl create -f frontend-service.yaml,redis-master-service.yaml,redis-slave-service.yaml,frontend-deployment.yaml,redis-master-deployment.yaml,redis-slave-deployment.yaml
service "frontend" created
service "redis-master" created
service "redis-slave" created
deployment "frontend" created
deployment "redis-master" created
deployment "redis-slave" created
```
 
<br>
 
#### Deploying/Generating Openshift manifests
 
* We can deploy manifest on openshift too by providing command line argument `--provider`:
 
```
$ kompose up --provider openshift
```
 
* for generating artifacts:
 
```
$ kompose convert --provider openshift
```
 
* or alternatively, you can set following environment variable: 
 
```
$ export PROVIDER=openshift
```
<br>

#### JSON output

* By default, kompose provides output in YAML format, but it can generate JSON output also if it's explicitely mentioned with command line arguements as `-j` or `--json`
 
 
```
$ kompose convert --json
INFO Kubernetes file "frontend-service.json" created 
INFO Kubernetes file "redis-master-service.json" created 
INFO Kubernetes file "redis-slave-service.json" created 
INFO Kubernetes file "frontend-deployment.json" created 
INFO Kubernetes file "redis-master-deployment.json" created 
INFO Kubernetes file "redis-slave-deployment.json" created
```
<br>
 
#### Store output artifacts to specific location
 
* Suppose we need to store output artifacts to some location, we can mention with command line arguments `-o`
 
```
$ kompose convert -o out/
INFO Kubernetes file "out/frontend-service.yaml" created 
INFO Kubernetes file "out/redis-master-service.yaml" created 
INFO Kubernetes file "out/redis-slave-service.yaml" created 
INFO Kubernetes file "out/frontend-deployment.yaml" created 
INFO Kubernetes file "out/redis-master-deployment.yaml" created 
INFO Kubernetes file "out/redis-slave-deployment.yaml" created 
```

<br>

#### Printing output
 
* If you want to print standard output instead of writing it to files
 
```
$ kompose convert --stdout
```

<br>

#### Replicas 
 
* As in docker-compose v2, replicas was not supported, you can provide number of replicas by using command line argument `--replicas`, default value of replicas is 1.
 
 
```
$ kompose convert --replicas=4
```
<br>

#### Empty Volumes

* If you don't want to generate PVCs, you can use empty volumes with command line arguments  `--emptyvols`.


```
$ kompose convert --emptyvols
```

<br>
 
#### Create daemonsets instead of deployment
 
* A DaemonSet ensures that all (or some) nodes run a copy of a pod. we can create daemonset manifests using `--daemon-set` flag.
 
```
$ kompose convert --daemon-set
```
 
<br>
 
#### Create Replication-Controller instead of deployment
 
* A ReplicationController ensures that a pod or set of pods are always up and available. we can create daemonset manifests using `--replication-controller` flag.
 
```
$ kompose convert --replication-controller
```
 
<br>

#### Delete Deployed manifests

* We can delete instantiated artifacts like service, deployments, etc using following command,

```
 $ kompose down 
INFO Deleting application in "myproject" namespace 
INFO Successfully deleted Service: frontend 
INFO Successfully deleted Service: redis-master 
INFO Successfully deleted Service: redis-slave 
INFO Successfully deleted Deployment: frontend 
INFO Successfully deleted Deployment: redis-master 
INFO Successfully deleted Deployment: redis-slave 
```

<br>
 
#### Add-ons
 
* as of now, all of the docker compose keys can not be mapped to k8s artifacts. Hence, for expose type, we have defined kompose specific labels as following:
 
```
 //defines if service needs to be made accessible from outside of cluster
labels:
kompose.service.expose: true
kompose.service.expose: "example.com"
```
 
* For service type:
 
```
//defines types of services to be created
labels:
kompose.service.type: nodeport/clusterip/loadbalancer
```

<br>

### [To be Continued...](http://localhost:1313/post/kompose-part-2/)
 
 

