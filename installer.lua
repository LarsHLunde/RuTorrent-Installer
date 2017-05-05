function file2table(file,atable)
	local fp = io.open(file, "r")
	for line in fp:lines() do
		table.insert (atable, line)
	end
	fp:close()
end

local commands = {}

file2table("./resources/commands.txt", commands)

print("Welcome to the Raspberry PI RuTorrent Installer")
print("created by Pyro_Killer")
print("It is currently in early pre-dev and will not work at all")

for i = 1, #commands do
	local x, y = commands[i]:find(";")
	print(commands[i]:sub(x+1))
	os.execute(commands[i]:sub(1,x-1))
end


os.execute("sudo lua ./resources/rewriter.lua ")
print("Restarting apache")
os.execute(sudo service apache2 restart >> /dev/null)
print("Starting rTorrent")
os.execute(screen -S rtorrent -fa -d -m rtorrent)