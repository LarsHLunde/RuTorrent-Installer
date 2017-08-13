--[[
File:						helper.lua
Version:				1.2
Author:				Pyro_Killer
Description:			Helper script for Debian/Devuan and VPSs

--]]

local isRoot = false

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

local function root()
	print("It would appear you are root")
end


print(commandOutput("sudo -v"))

print("Are you the very  model of a modern major general")
print(YesorNo())