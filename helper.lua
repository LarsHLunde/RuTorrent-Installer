--[[
File:						helper.lua
Version:				1.2
Author:				Pyro_Killer
Description:			Helper script for Debian/Devuan and VPSs

--]]

local isRoot = false
local newUser = ""

local function getInput(question)
	io.write(question)
	io.flush()
	return io.read()
end


local function commandOutput(command)
	local file = assert(io.popen(command, 'r'))
	local output = file:read('*all')
	file:close()
	return output
end

local function YesorNo()
	local answer
	repeat
		io.write("Please answer with y for yes, or n for no: ")
		io.flush()
		answer=io.read()
	until answer=="y" or answer=="n"

	if answer == "y" then
		return true
	else
		return false
	end

end

local function continue()
	local answer
	repeat
		io.write("Are you sure you want to continue? y for yes, or n for no: ")
		io.flush()
		answer=io.read()
	until answer=="y" or answer=="n"

	if answer == "n" then
		os.exit()
	end

end

function swap()
	print("Doing swap stuff")

end

pwd = commandOutput("pwd")
pwd = pwd:sub(1, pwd:len()-1)

if commandOutput("whoami") == "root\n" or true then
	isRoot = true
	print("It would appear you are root")
	print("If you have another user it is advisable")
	print("to use that one instead, or we will make")
	print("a new user for this installation.")
	continue()
	os.execute("mkdir /home 2> /dev/null")
	print("Updating package manager")
	os.execute("apt-get update > /dev/null")
	print("Installing sudo")
	os.execute("apt-get install sudo > /dev/null")
	newUser = getInput("Please enter new users name: ")
	os.execute("useradd -m " .. newUser)
	print("Please add a password for the new user:")
	os.execute("passwd " .. newUser)
	print("Adding user to sudo group")
	os.execute("adduser " .. newUser .. " sudo")
	
	swap()
	
	print("The script will now start the main script installation script")
	continue()
	os.execute("sudo -A -s /bin/bash -u " .. newUser .. " \"cd ~ && git clone https://github.com/LarsHLunde/RuTorrent-Installer.git && cd RuTorrent-Installer && lua installer.lua\"")
end

-- git clone -b test https://github.com/LarsHLunde/RuTorrent-Installer.git && cd RuTorrent-Installer && lua helper.lua