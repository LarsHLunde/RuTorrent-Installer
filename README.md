# RuTorrent-Installer v1.1

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
* Raspbian

### Presumed working
* Armbian Jessie
* Armbian Xenial

## Not working (yet)
* Ubuntu 14.04 64-bit
* Ubuntu 14.04 32-bit

## Dependecies
This script installer is made in Lua,
and as such Lua is required.
For people running Debian and Devuan please see notes
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

## Changelog
### Version 1
Initial working release
### Version 1.01
* Fixed ownership of rtorrent.rc file
* Re-added seedtime in config

### Version 1.1
* Made compatible with Ubuntu 16.04
* Lost comaptibility for Ubuntu 14.04

## Planned features


* Make dialog screens, which I need to learn how to use
* Make script safe to run multiple times without side effects
* Add support for nginx
* Maybe add support for lighttpd
* Add support for using the reposetory versions of xml-rpc, rtorrent and libtorrent

## Notes
I have made the not about the Debian and Devuan on which I test
that "sudo" is not installed by default. This program does however depend
on you being a sudoer. To check if you are a sudoer type in.

```
sudo -v
```

It should't return anything ask you for your password and return nothing, 
if you get any other message, do the following steps:  
**_WARNING_: This presumes that you have control over the root user of the system**

1. Log in as root
```
su root
```

2. Install sudo program
```
apt-get install sudo
```

3. Add your user to the sudoer group
```
adduser MYUSER sudo
```

4. Log out of root and normal user

```
exit
exit
```

5. Log back in as the your regular user

6. Check that you are part of the sudoers
It should ask for your password and return nothing
```
sudo -v
```

You can repeat this proccess if needed
