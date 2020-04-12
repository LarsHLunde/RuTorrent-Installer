# RuTorrent-Installer v1.3.2

## Description
This is a RuTorrent installer for debian based linux systems.
My original goal for the project was to make a RuTorrent installer
for the Raspberry Pi 3 running Raspbian-jessie-lite 
but found quickly that it worked on many different Debian based systems.

It downloads and compiles XML-RPC, LibTorrent and rTorrent,
or downloads them from the repo if rTorrent is 0.9.6,
and runs on apache2 web server.

## Systems
Operating System | State
--- | ---
Ubuntu 18.04 | :heavy_check_mark:
Debian Buster | :x: <sup>1</sup>
Raspbian Buster | :x: <sup>1</sup>
Armbian Buster | :x: <sup>1</sup>
Ubuntu 16.10 - 17.10 | :question: <sup>2</sup>
Ubuntu 16.04 | :heavy_check_mark:
Debian Jessie | :heavy_check_mark:
Debian Stretch | :heavy_check_mark:
Devuan Jessie | :heavy_check_mark:
Devuan ASCII | :heavy_check_mark:
Raspbian Stretch | :heavy_check_mark:
Raspbian Jessie | :heavy_check_mark:
Armbian Xenial | :heavy_check_mark:
Armbian Stretch | :heavy_check_mark:
Armbian Jessie | :heavy_check_mark:

1. I am in the testing phase of making script specific to Buster
2. In theory it should work on these systems, I have no intention of testing them


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
sudo apt-get install -y lua5.2 git sox
git clone https://github.com/LarsHLunde/RuTorrent-Installer.git
cd RuTorrent-Installer
lua installer.lua
```

or just copy the monster line in to your terminal:
```
sudo apt-get update && sudo apt-get install -y lua5.2 git sox && git clone https://github.com/LarsHLunde/RuTorrent-Installer.git && cd RuTorrent-Installer && lua installer.lua
```



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

1. Copy and paste this line in to terminal:
```
su - root -c "apt-get install sudo -y && adduser $USER sudo"
```

2. Enter the root user password

3. Type in 
```
exit
```
4. Log back in and check that you are part of the sudoers
It should ask for your password and return nothing
```
sudo -v
```

You can repeat this proccess if needed

## Changelog
Description | Version | State
--- | --- | ---
Changed command files to work with Ubuntu 18.04 | v1.3.2 | release
Changed low disk space limit for 10GB to 100MB in .rtorrent.rc | v1.3.1 | release
Added a support script for the liteserver.nl VPSs<br>Added support for Debian stretch<br>Cleaned up some hacks<br>Made script clean itself up| v1.3 | release
Added support for repo installation | v1.2 | release
Made compatible with Ubuntu 16.04<br>Lost comaptibility for Ubuntu 14.04 | v1.1 | release
Fixed ownership of rtorrent.rc file <br>Re-added seedtime in config | v1.0.1 | beta
Initial working release | v1.0 | beta

