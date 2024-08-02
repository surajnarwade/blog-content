+++
date = "2017-09-26T21:21:49+05:30"
title = "Easter eggs in kubectl"
category = "Blog"
author = "Suraj Narwade"

+++

I was watching video about kubectl by [janakiram](https://twitter.com/janakiramm) and surprising I found there is also world of commands rather than `create`, `delete`, `get`. `kubectl` has lots of interesting easter eggs.

Some of the cool things I found as below,

* List pod along with node name on which they are running

```
kubectl get pods -o wide
```

* If you want yaml or json configurations of your application(maybe pod,deployment or service,etc)

```
kubectl get pod web -o=yaml/json
```

* CLI hacks to retrieve minimal information (In this case, pod name and node name)

```
kubectl get pod -o wide | awk {'print $1" " $7'} | column -t
```

* you can directly edit configurations

```
kubectl edit pod/web
```

* You can mention editor of your choice using `KUBE_EDITOR` variable,

```
KUBE_EDITOR="sublime" kubectl edit pod/web
```

* If we want to get any specific thing from configurations

```
kubectl get pods web -o jsonpath={.spec.containers[*].name}
```

* `cordon` will mark node as unschedulable

```
kubectl cordon <ip-of-node> 
```

* `uncordon` will mark node as schedulable again

```
kubectl uncordon <ip-of-node>  
```

* The given node will be marked unschedulable to prevent new pods from arriving. 'drain' evicts the pods . Otherwise, The 'drain' evicts or deletes all pods except replicationcontrollers pods, etc

```
kubectl drain <node>
```

* Drain node "foo", even if there are pods not managed by a ReplicationController, ReplicaSet,
Job, DaemonSet or StatefulSet on it

```
kubectl drain <node> --force
```

* Create proxy server between `localhost` and kubernetes API server

```
kubectl proxy 
```

* you can mention port of your choice as well,

```
kubectl proxy --port=8000
```

* We can forward local ports to pod (useful for debugging frontend application)

```
kubectl port-forward <pod_name> <host_port>:<container_port>
```

* Copy files to and from container to our machine

```
kubectl cp <file> <podname>:<path>
```

* Sometime you need shortcuts to increase your speed, productivity something like `po` for `pods`, `deploy` for `deployments`, you can find all shortcuts here,

```
kubectl explain
```


Thanks [janakiram](https://twitter.com/janakiramm) for awesome tutorial.

### Reference

* https://www.youtube.com/watch?v=BadzJOlSn24
* https://twitter.com/janakiramm



 




