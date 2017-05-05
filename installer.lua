function file2table(file,atable)
	local fp = io.open(file, "r")
	for line in fp:lines() do
		table.insert (atable, line)
	end
	fp:close()
end

local commands = {}

file2table("./resources/commands.txt", commands)

local whoami = assert(io.popen("whoami", "r"))
local homedir = whoami:read('*all')
whoami:close()
homedir = "/home/" .. homedir:sub(1,homedir:len()-1)
torrentdir = homedir .. "/rtorrent"

print("Welcome to the Raspberry PI RuTorrent Installer")
print("created by Pyro_Killer")
print("It is currently in early pre-dev and will not work at all")
print("Checking for a working internet connection")
os.execute("wget http://detectportal.firefox.com/success.txt 2> /dev/null")

local internetcheck = io.open("success.txt","r")

if internetcheck == nil then
	print("There appears to be no internet connection")
	os.exit()

else
	print("Internet connection confirmed")
	internetcheck:close()
	os.execute("rm success.txt")
end

print("Please enter location of torrent downloads")
print("If you use the same media as your system is on")
print("the entire operating system will start getting stuttery")
print("So I suggest you use something like a USB stick or ")
print("external hard drive. Press enter to leave as default")
io.write("[" .. torrentdir .. "]")
--[[
for i = 1, #commands do
	local x, y = commands[i]:find(";")
	print(commands[i]:sub(x+1))
	os.execute(commands[i]:sub(1,x-1))
end

--]]

---[[


--[[
os.execute("sudo lua ./resources/rewriter.lua ".. somethingorother .. homedir)
print("Restarting apache")
os.execute("sudo service apache2 restart >> /dev/null")
print("Starting rTorrent")
os.execute("screen -S rtorrent -fa -d -m rtorrent")
--]]

