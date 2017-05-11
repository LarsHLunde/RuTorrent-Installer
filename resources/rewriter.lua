-- The first argument is where the rTorrent  directory files should be placed. 
-- The second argument is the home directory of the user
-- The third argument is the user name

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

print("Rewriting rutorrent config file")
local config_file = "/var/www/html/rutorrent/conf/config.php"
local config_keywords = {"\"php\" 	=>","\"curl\"	=>","\"gzip\"	=>","\"id\"	=>","\"stat\"	=>", "$topDirectory"}
local config_replacees = {"\'\'","\'\'","\'\'","\'\'","\'\'","\'/\'"}
local config_replacers = {"'/usr/bin/php'","'/usr/bin/curl'","'/bin/gzip'","'/usr/bin/id'","'/usr/bin/stat'","\'".. arg[1] .. "\'"}
replaceVars(config_file,config_keywords,config_replacees,config_replacers)


print("Adding rtorrent to startup")
local startup_fix_file = "/etc/rc.local"
local startup_fix_indentifier = "su -c \"screen -S rtorrent -fa -d -m rtorrent\" " .. arg[3]
local startup_fix_replacer = ""
replaceLine(startup_fix_file,startup_fix_indentifier,startup_fix_replacer)

local startup_file = "/etc/rc.local"
local startup_indentifier  = "exit 0"
local startup_replacer = "su -c \"screen -S rtorrent -fa -d -m rtorrent\" " .. arg[3] ..  "\nexit 0"
replaceLine(startup_file,startup_indentifier,startup_replacer)


print("Rewriting .rtorrent.rc")
local torrentrc_file = arg[2] .. "/.rtorrent.rc"
local torrentrc_keywords = {"KEYWORD"}
local torrentrc_replacees = {"KEYWORD"}
local torrentrc_replacers = {arg[1]}
replaceVars(torrentrc_file,torrentrc_keywords,torrentrc_replacees,torrentrc_replacers)

print("Rewriting /etc/apache2/apache2.conf")
local apache_file = "/etc/apache2/apache2.conf"
local apache_indentifier = "Timeout"
local apache_replacer = "Timeout 30"
replaceLine(apache_file,apache_indentifier,apache_replacer)

print("Rewriting /etc/apache2/sitest-enabled/000-default.conf")
local default_conf_file = "/etc/apache2/sitest-enabled/000-default.conf"
local default_conf_indentifier = "</VirtualHost>"
local default_conf_replacer = "\t<Directory \"/var/www/html/rutorrent\">\n\t\tAuthName \"RuTorrent Login\"\n\t\tAuthUserFile /etc/apache2/.htpasswd\n\t\tRequire valid-user\n\t</Directory>\n</VirtualHost>"
replaceLine(default_conf_file,default_conf_indentifier,default_conf_replacer)


