+++
title = "How to install OpenStack-packstack from source and test individual patches locally!"
date = "2016-11-03"
category = "OpenSource"
author = "Suraj Narwade"

+++

Yesterday I was reading about magnum component in OpenStack, then I checked with installing OpenStack Newton by following [RDO doc](https://www.rdoproject.org/install/quickstart/). but it seems that, packstack answer file is not ready with magnum component yet. but fortunately, I found a patch https://review.openstack.org/#/c/360388/  about adding magnum deployment in packstack, so I decided to test this patch via installing openstack-packstack through source as per discussion with [Chandan Kumar](https://twitter.com/ciypro) and [Javier Peña](https://twitter.com/fj_pena)
1. have used centos 7 box for this purpose.
   

*Installation*
```
 $ sudo yum install -y git python-pip
 $ git clone git://github.com/openstack/packstack.git
```
then, I have to download that patchset, for that, I installed git-review

```
 $ sudo pip install git-review
 $ cd packstack
```
Make sure you have configured your gerrit credentails on [OpenStack Gerrit](review.openstack.org) for reference, http://docs.openstack.org/infra/manual/developers.html

```
 $ git remote -s # It will ask for openstack gerrit username
 $ git review -d <change-id of patchset>
 $ git rebase -i master
 $ sudo python setup.py install
```
installation of OpenStack-puppet-modules

```
 $ export GEM_HOME=/tmp/somedir
 $ sudo yum install rubygems -y
 $ gem install r10k
```
We have used sudo -E, because it preserves environment variables as we declared GEM_HOME

```
 $ sudo -E /tmp/somedir/bin/r10k puppetfile install -v
 $ sudo cp -r packstack/puppet/modules/packstack /usr/share/openstack-puppet/modules
```
Now it's time to generate answer file and edit the  contents:
as my target was Magnum component,

```
 # packstack -d --gen-answer-file=answerfile.txt
```
```
 # Specify 'y' to install OpenStack Container Service (magnum). ['y',
 # 'n']
 CONFIG_MAGNUM_INSTALL=y
```
Run the packstack by giving path of answerfile

```
 # packstack -d  --answer-file=answerfile.txt
```
In this way, I tested patch with packstack locally. I will write about Magnum component in next blog post.

Happy Hacking!

