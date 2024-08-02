+++
date = "2018-11-15T21:21:49+05:30"
title = "nmcli 101"
category = "Blog"
author = "Suraj Narwade"

+++


* To check devices:
  
```
nmcli device status
```

* Overall status of NetworkManager:

```
nmcli general status
```

* Display connections:

```
nmcli connection show
```

* display only active connections:

```
nmcli connection show --active
```

WI-FI
-----

* Check wifi status
  
```
nmcli radio wifi
```

* Turn on the wifi

```
nmcli radio wifi on
```

* Turn off the wifi

```
nmcli radio wifi off
```

* List available wifi access points

```
nmcli device wifi list
```

* Refresh the access point list

```
nmcli device wifi rescan
```

* Connect to wifi

```
nmcli device wifi connect <SSID>
```

* Connect to password protected access point

```
nmcli device wifi connect <SSID> password <password>
```