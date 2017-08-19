--[[
File:						helper.lua
Version:				1.2
Author:				Pyro_Killer
Description:			Helper script for Debian/Devuan and VPSs

--]]


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

function liteserver()
	print("If you have another user it is advisable")
	print("to use that one instead, or we will make")
	print("a new user for this installation.")
	continue()
	print("Updating package manager")
	os.execute("apt-get update >> /dev/null")
	print("Installing build essentials (special case")
	os.execute("apt-get install build-essential")
	print("Installing sudo")
	os.execute("apt-get install sudo -y >> /dev/null")
	os.execute("locale-gen en_US.UTF-8 ")
	print("Updating locale configuration")
	os.execute("update-locale LC_ALL=en_US.UTF-8")
	print("Adding a new user")
	newUser = getInput("Please enter new users name: ")
	os.execute("useradd -m " .. newUser)
	print("Adding a password for the new user")
	os.execute("passwd " .. newUser)
	print("Adding user to sudo group")
	os.execute("adduser " .. newUser .. " sudo")
	

	print("The script will now start the main script installation script")
	continue()
	os.execute("sudo -H -u " .. newUser ..  " bash ./resources/liteserver.sh")
	print("Script is done")
end

function exit_func()
	print("Cleaning up..")
	os.execute("cd .. && rm RuTorrent-Installer/ -rf")
	os.exit()
end

while true do
	local choice = getInput("1. liteserver installer script\n0. Exit\n")
	
	if choice == "0" then
		exit_func()
	elseif choice == "1" then
		liteserver()
	end
	
end
