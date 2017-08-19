--[[
File:						rewriter.lua
Version:				1.3
Author:				Pyro_Killer
Description:			Rewrites system files with
							required configurations for RuTorrent
							to work,

Called by:			installer.lua
Argument 1:		rTorrent directory
Argument 2:		user home directory
Argument 3:		user name
--]]

-- Finds a line in a file containing a keywords
-- and replaces part of the line with something else.
-- Argument: file - The file to be modified
-- Argument: keywords - A table of keywords that indentifies
-- the lines to be replaced
-- Argument: replacees - A table of parts of identified 
-- strings that is to be replaced
-- Argument: replacers - A table of replacement strings
-- for the for the replacees to be replaced by
function replaceVars(file,keywords,replacees,replacers)
	local edit_file = io.open(file, "r")
	local text = {}
	
	for line in edit_file:lines() do
		table.insert (text, line)
	end
	edit_file:close()
	
	for i = 1, #text do
		for j = 1, #keywords do
			if text[i]:match(keywords[j]) then
				text[i] = text[i]:gsub(replacees[j],replacers[j])
			end
		end
	end
	
	edit_file = io.open(file, "w")
	
	for i = 1, #text do
		edit_file:write(text[i] .. "\n")
	end
	edit_file:close()

end

-- Finds a line in a file and replaces the line with a replacer
-- Argument: file - The file to be modified
-- Argument: identifier - The start of the line to be replaced
-- Argument: replacer - The line to replace the identified line

function replaceLine(file,indentifier,replacer)
	local edit_file = io.open(file, "r")
	local text = {}
	
	for line in edit_file:lines() do
		table.insert (text, line)
	end
	edit_file:close()
	
	for i = 1, #text do
		if text[i]:sub(1,indentifier:len()) == indentifier then
			text[i] = replacer
		end
	end
	
	edit_file = io.open(file, "w")
	
	for i = 1, #text do
		edit_file:write(text[i] .. "\n")
	end
	edit_file:close()

end

-- Checks if there is an rc.local file, and if there isn't one, creates one
local rc_local = io.open("/etc/rc.local","r")

if rc_local == nil then
	rc_local = io.open("/etc/rc.local","w")
	rc_local:write("#!/bin/sh -e\nexit 0")
	os.execute("chmod +x /etc/rc.local")
end

rc_local:close()


-- Rewrites the RuTorrent config file to know the basic linux commands
print("Rewriting rutorrent config file")
local config_file = "/var/www/html/rutorrent/conf/config.php"
local config_keywords = {"\"php\" 	=>","\"curl\"	=>","\"gzip\"	=>","\"id\"	=>","\"stat\"	=>", "$topDirectory"}
local config_replacees = {"\'\'","\'\'","\'\'","\'\'","\'\'","\'/\'"}
local config_replacers = {"'/usr/bin/php'","'/usr/bin/curl'","'/bin/gzip'","'/usr/bin/id'","'/usr/bin/stat'","\'".. arg[1] .. "\'"}
replaceVars(config_file,config_keywords,config_replacees,config_replacers)

-- First checks if rTorrent already exist in the rc.local file
-- and removes it if it exists, then places it back in.
print("Adding rtorrent to startup")
local startup_fix_file = "/etc/rc.local"
local startup_fix_indentifier = "su -c \"screen -S rtorrent -fa -d -m rtorrent\" " .. arg[3]
local startup_fix_replacer = ""
replaceLine(startup_fix_file,startup_fix_indentifier,startup_fix_replacer)

local startup_file = "/etc/rc.local"
local startup_indentifier  = "exit 0"
local startup_replacer = "su -c \"screen -S rtorrent -fa -d -m rtorrent\" " .. arg[3] ..  "\nexit 0"
replaceLine(startup_file,startup_indentifier,startup_replacer)

-- Inserts the directories that rTorrent requires to work
print("Rewriting .rtorrent.rc")
local torrentrc_file = arg[2] .. "/.rtorrent.rc"
local torrentrc_keywords = {"KEYWORD"}
local torrentrc_replacees = {"KEYWORD"}
local torrentrc_replacers = {arg[1]}
print(torrentrc_file)
print(torrentrc_file)
replaceVars(torrentrc_file,torrentrc_keywords,torrentrc_replacees,torrentrc_replacers)

-- Changes the apache timeout from default, usually 300 seconds
-- to 30 seconds to accommodate the UI.
print("Rewriting /etc/apache2/apache2.conf")
local apache_file = "/etc/apache2/apache2.conf"
local apache_indentifier = "Timeout"
local apache_replacer = "Timeout 30"
replaceLine(apache_file,apache_indentifier,apache_replacer)


