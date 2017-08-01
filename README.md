<<<<<<< HEAD
# RuTorrent-Installer v1.01
=======
# RuTorrent-Installer v1.1
>>>>>>> refs/remotes/origin/master

## Description
This is a RuTorrent installer for debian based linux systems.
My original goal for the project was to make a RuTorrent installer
for the Raspberry Pi 3 running Raspbian-jessie-lite but found quickly
that it worked on many different Debian based systems.

It downloads and compiles XML-RPC, LibTorrent and rTorrent,
and runs on apache2 web server.

## Systems
### Working and tested
* Ubuntu 16.04 64-bit
* Ubuntu 16.04 32-bit
* Debian Jessie 64-bit
* Debian Jessie 32-bit
* Devuan Jessie 64-bit
* Devuan Jessie 32-bit

### Presumed working
* Raspbian
* Armbian Jessie
* Armbian Xenial

## Not working (yet)
* Ubuntu 14.04 64-bit
* Ubuntu 14.04 32-bit

## Dependecies
This script installer is made in Lua,
and as such Lua is required.
For people running Debian please see notes
further down the page.

## Installment
In order to install RuTorrent on your pi
copy and paste every individual line in
to your console.
```
sudo apt-get update
sudo apt-get install -y lua5.2 git
git clone https://github.com/LarsHLunde/RuTorrent-Installer.git
cd RuTorrent-Installer
lua installer.lua
```

or just copy the monster line in to your terminal:
```
sudo apt-get update && sudo apt-get install -y lua5.2 git && git clone https://github.com/LarsHLunde/RuTorrent-Installer.git && cd RuTorrent-Installer && lua installer.lua
```

<<<<<<< HEAD
##Changelog
###Version 1
Initial working release
###Version 1.01
* Fixed ownership of rtorrent.rc file
* Re-added seedtime in config

## Future releases
### Version 1.1
* Add support for xenial with its php7
=======
## Changelog
### Version 1
Initial working release
### Version 1.01
* Fixed ownership of rtorrent.rc file
* Re-added seedtime in config

### Version 1.1
* Made compatible with Ubuntu 16.04
* Lost comaptibility for Ubuntu 14.04

## Future releases
>>>>>>> refs/remotes/origin/master

### Version 1.2
* Add comments and misc other documentation.
* Make dialog screens, which I need to learn how to use
* Make script safe to run multiple times without side effects

### Version 1.3
* Add support for nginx
* Maybe add support for lighttpd

### Version 1.4
* Add support for using the reposetory versions of xml-rpc, rtorrent and libtorrent

## Notes
I have made the not about the Debian netinst on which I test
that "sudo" is not installed by default. This program does however depend
on you being a sudoer. To check if you are a sudoer type in.

```
sudo -v
```

It should't return anything, if you get any other message, do the following steps:

1. Presuming that you have and know the root password:
```
su root
apt-get install sudo && visudo
```
This should open the nano text editor with the sudoer file.

2. Find the following line
```
root  ALL=(ALL:ALL) ALL
```

and then add your username in the same format
on the line under it
```
myuser ALL=(ALL:ALL) ALL
```
3. Done, you are now a super user in debian, run 

```
sudo -v
```
again to confirm