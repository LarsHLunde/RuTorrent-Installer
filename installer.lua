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

