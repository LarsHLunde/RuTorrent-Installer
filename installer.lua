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

function file2table(file,atable)
	local fp = io.open(file, "r")
	for line in fp:lines() do
		table.insert (atable, line)
	end
	fp:close()
end

local messages = {}
local commands = {}

file2table("./resources/messages.txt", messages)
file2table("./resources/commands.txt", commands)

print(messages[1])
print(messages[2])
print(messages[3])

for i = 1, #commands do
	local x, y = commands[i]:find(";")
	print(commands[i]:sub(x+1))
	os.execute(commands[i]:sub(1,x-1))

end

local config_file = "./config.php"
local config_keywords = {"\"php\" 	=>","\"curl\"	=>","\"gzip\"	=>","\"id\"	=>","\"stat\"	=>"}
local config_replacees = {"\'\'","\'\'","\'\'","\'\'","\'\'"}
local config_replacers = {"'/usr/bin/php'","'/usr/bin/curl'","'/bin/gzip'","'/usr/bin/id'","'/usr/bin/stat'"}

--replaceVars(config_file,config_keywords,config_replacees,config_replacers)