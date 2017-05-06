# RuTorrent-Installer
# WARNING: This program does not work yet
## Dependecies
This script installer is made in Lua,
and as such Lua is required.


## Installment
In order to install RuTorrent on your pi copy
this in to your terminal on individual lines
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
