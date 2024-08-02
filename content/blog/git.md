+++
date = "2017-11-27T21:21:49+05:30"
title = "How to split commits in git"
category = "Blog"
author = "Suraj Narwade"

+++

I am very bad at git and I always forget the steps. It's always better to write it somewhere. Then why not a blog ? 


To split your last or recent commit, simply do, 

```
$ git reset HEAD~
```

But I wanted to break 3rd commit and split it into two commits, then I did as following way,

```
$ git rebase -i HEAD~3
```

if you dont know the number you can also mention `SHA1` of that commit as well,

```
$ git rebase master -i xyz^
```

Then rebase screen will appear, replace `pick` with `edit` and save it and do,

```
$ git reset HEAD~
```
Now Commit the individual files and create as much commit as you want and finally do,

```
$ git rebase --continue
```


``Happy Hacking !!!``

#### Reference:
 
 * https://stackoverflow.com/questions/6217156/break-a-previous-commit-into-multiple-commits

