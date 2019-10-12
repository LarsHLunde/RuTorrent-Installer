--[[
File:						installer.lua
Version:				1.3
Author:				Pyro_Killer
Description:			Main install script for the installer.

Dependencies:	resources/rewriter.lua							v1.3
							resources/commands_compile.txt		v1.3
							resources/commands_install.txt			v1.3
--]]

-- Takes a text file and puts each individual
-- line of the file in to a file
-- First variable is the file path
-- Second variable is the table to write the data to
function file2table(file,atable)
	local fp = io.open(file, "r")
	for line in fp:lines() do
		table.insert (atable, line)
	end
	fp:close()
end

-- Creates a command table and inserts commands
--  from the commands.txt in to a table
local commands_compile = {}
file2table("./resources/commands-compile.txt", commands_compile)

local commands_install = {}
file2table("./resources/commands-install.txt", commands_install)

-- Gets the users home user id, home directory and default rtorrent
-- directory for use in the rewriter and other misc
local tempvar = ""

local whoami = assert(io.popen("whoami", "r"))
tempvar = whoami:read('*all')
whoami:close()

local uid = tempvar:sub(1,tempvar:len()-1)

local cd_pwd = assert(io.popen("cd ~ && pwd", "r"))
tempvar = cd_pwd:read('*all')
cd_pwd:close()

local homedir = tempvar:sub(1,tempvar:len()-1)
local torrentdir = homedir .. "/rtorrent"
local compile = true

-- Welcome messages
print("Welcome to the RuTorrent Installer")
print("created by Pyro_Killer")
print("It works on Ubuntu 16.04 and Debian for ARM and other architectures")

-- Check for a captive portal and working internet connection
print("Checking for a working internet connection")
os.execute("wget http://detectportal.firefox.com/success.txt 2> /dev/null")
local internetcheck = io.open("success.txt","r")

if internetcheck == nil then
	print("There appears to be no internet connection or you don't have write privileges in this folder")
	os.exit()

else
	print("Internet connection confirmed")
	internetcheck:close()
	os.execute("rm success.txt")
end


-- Check if repo version of rtorrent is the correct one
print("Updating package listings")
os.execute("sudo apt-get update >> /dev/null")
print("Checking repo version of rTorrent")
local apt_cache = assert(io.popen("sudo apt-cache policy rtorrent", "r"))
tempvar = apt_cache:read('*all')
apt_cache:close()

if tempvar:match("0.9.6") or tempvar:match("0.9.7") then
	print("It appears we don't need to compile")
	compile = false
else
	print("It appears you have to compile from source")
end


-- User input for custom rtorrent directory
print()
print("Please enter location of the rtorrent downloads")
print("If you are runing this on a single board computer like RPi")
print("I reccomend using an external HDD or USB stick or")
print("the entire operating system will start getting stuttery")
print()
print("Press enter to leave as default")
io.write("[" .. torrentdir .. "]")
io.flush()
local inputdir = io.read()

if inputdir ~= "" then
	torrentdir = inputdir
end

local dircheck = assert(io.popen("cd " .. torrentdir .. " 2>&1", "r"))
local dircheck_data = dircheck:read('*all')
dircheck:close()

-- If the user inputs a custom location this checks that
-- the directory is valid
if dircheck_data ~= "" then
	local super_dir = torrentdir:reverse()
	local new_dir = super_dir:sub(1,super_dir:find("/" )-1)
	super_dir = super_dir:sub(super_dir:find("/" )+1)
	new_dir = new_dir:reverse()
	super_dir = super_dir:reverse()
	
	dircheck = assert(io.popen("cd " .. super_dir .. " 2>&1", "r"))
	local dircheck_data = dircheck:read('*all')
	dircheck:close()
	
	if dircheck_data == "" then
		os.execute("cd  " .. super_dir .. " && mkdir " .. new_dir )
	else	
		print("The location you entered is invalid")
		os.exit()
	end

end

print(torrentdir .. " will be used as rtorrent directory")

if torrentdir:sub(torrentdir:len()) == "/" then 
	torrentdir = torrentdir:sub(1,torrentdir:len()-1) 
end

-- Creates the required directories for  rtorrent to work
os.execute("sudo mkdir " ..  torrentdir .. "/.session")
os.execute("sudo mkdir " ..  torrentdir .. "/watch")
os.execute("sudo chown -R " .. uid .. " " .. torrentdir)

-- Runs all the commands in the commands.txt file
if compile then
	for i = 1, #commands_compile do
		if commands_compile[i]:sub(1,1) ~= "#" then
			local x, y = commands_compile[i]:find(";")
			print(commands_compile[i]:sub(x+1))
			os.execute(commands_compile[i]:sub(1,x-1))
		end
	end
else
	for i = 1, #commands_install do
		if commands_install[i]:sub(1,1) ~= "#" then
			local x, y = commands_install[i]:find(";")
			print(commands_install[i]:sub(x+1))
			os.execute(commands_install[i]:sub(1,x-1))
		end
	end
end

-- Runs the file rewriter script in resources/rewriter.lua
os.execute("sudo chown " .. uid .. " ~/.rtorrent.rc" )
os.execute("sudo lua ./resources/rewriter.lua ".. torrentdir .. " " .. homedir .. " " .. uid)

-- Asks the user for desired username and password for the RuTorrent Login
print("Please enter the username for the RuTorrent login")
io.write("Login: ")
io.flush()
local login = io.read()
os.execute("sudo htpasswd -c /etc/apache2/.htpasswd " .. login)

-- Restarts apache and starts rtorrent
print("Restarting apache")
os.execute("sudo service apache2 restart >> /dev/null")
print("Starting rTorrent")
os.execute("screen -S rtorrent -fa -d -m rtorrent")

print("Listening port is: 55555")
print("Cleaning up")
os.execute("cd ~ && rm RuTorrent-Installer/ -rf")

