+++
date = "2017-07-06T21:21:49+05:30"
title = "tools to adopt best practices in golang"
category = "Blog"
author = "Suraj Narwade"

+++


I went through internet yesterday regarding best practices with golang, I found [go-tools](https://github.com/dominikh/go-tools)  written by [Dominik Honnef](https://twitter.com/dominikhonnef) which were pretty interesting and can be .
I found some of them useful for me, so are they listed below.

### static check


* applies tons of static analysis checks.

* it needs go 1.6 or later,

```
go get honnef.co/go/tools/cmd/staticcheck
```

* syntax is:

```
$ statickcheck [pkg] or [directory]
```

* I tried it for kompose with some extra hacks:


```
$ for pkg in $(go list -f '{{ join .Deps  "\n"}}' . | grep 'kompose/[^vendor]'); do staticcheck "$pkg"; done
cmd/completion.go:48:2: empty branch (SA9003)
pkg/transformer/kubernetes/kubernetes_test.go:71:6: identical expressions on the left and right side of the '!=' operator (SA4000)
```

### gosimple

* it gives suggestions for simplifying your code.

* it needs go 1.6 or later:

```
go get honnef.co/go/tools/cmd/gosimple
```

* syntax is:

```
$ gosimple [pkg] or [directory]
```

* I tried it as follows:

```
$ for pkg in $(go list -f '{{ join .Deps  "\n"}}' . | grep 'kompose/[^vendor]'); do gosimple "$pkg"; done
pkg/transformer/utils.go:219:2: 'if err != nil { return err }; return nil' can be simplified to 'return err' (S1013)
pkg/transformer/utils_test.go:115:4: the argument is already a string, there's no need to use fmt.Sprintf (S1025)
pkg/transformer/kubernetes/k8sutils.go:346:3: should replace loop with volumes = append(volumes, TmpVolumes...) (S1011)
pkg/transformer/kubernetes/k8sutils.go:349:3: should replace loop with volumesMount = append(volumesMount, TmpVolumesMount...) (S1011)
pkg/transformer/kubernetes/k8sutils.go:414:6: should omit comparison to bool constant, can be simplified to service.Privileged (S1002)
pkg/transformer/kubernetes/k8sutils_test.go:206:7: should omit comparison to bool constant, can be simplified to !hostPid (S1002)
pkg/transformer/kubernetes/k8sutils_test.go:243:8: should omit comparison to bool constant, can be simplified to hostPid (S1002)
pkg/transformer/kubernetes/k8sutils_test.go:275:5: should omit comparison to bool constant, can be simplified to !output (S1002)
pkg/transformer/kubernetes/k8sutils_test.go:284:5: should omit comparison to bool constant, can be simplified to output (S1002)
pkg/transformer/kubernetes/k8sutils_test.go:293:5: should omit comparison to bool constant, can be simplified to output (S1002)
pkg/transformer/kubernetes/kubernetes_test.go:183:68: should omit comparison to bool constant, can be simplified to !*template.Spec.Containers[0].SecurityContext.Privileged (S1002)
pkg/utils/docker/client.go:31:2: 'if err != nil { return client, err }; return client, nil' can be simplified to 'return client, err' (S1013)
```

### unused

* it checks for unused constants, variables, functions and types.

* it needs go 1.6 or later

```
go get honnef.co/go/tools/cmd/unused
```

* syntax is:

```
$ unused [pkg] or [directory]
```

* again, I tried it on kompose, purposefully I have added some unused type and function:

```
$ for pkg in $(go list -f '{{ join .Deps  "\n"}}' . | grep 'kompose/[^vendor]'); do unused "$pkg"; done
pkg/kobject/kobject.go:126:6: type abc is unused (U1000)
pkg/kobject/kobject.go:130:6: func hello is unused (U1000)
```

### `Happy Hacking !!!`


#### References:

* https://dave.cheney.net/2014/09/14/go-list-your-swiss-army-knife
* https://github.com/dominikh/go-tools
