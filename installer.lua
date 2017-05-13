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
local uid = homedir:sub(1,homedir:len()-1)
homedir = "/home/" .. homedir:sub(1,homedir:len()-1)
local torrentdir = homedir .. "/rtorrent"

print("Welcome to the RuTorrent Installer")
print("created by Pyro_Killer")
print("It works on Ubuntu 14.04 and Debian for ARM and other architectures")
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

os.execute("sudo mkdir " ..  torrentdir .. "/.session")
os.execute("sudo mkdir " ..  torrentdir .. "/watch")
os.execute("sudo chown -R " .. uid .. " " .. torrentdir)



for i = 1, #commands do
	if commands[i].sub(1,1) ~= "#" then
		local x, y = commands[i]:find(";")
		print(commands[i]:sub(x+1))
		os.execute(commands[i]:sub(1,x-1))
	end
end





os.execute("sudo lua ./resources/rewriter.lua ".. torrentdir .. " " .. homedir .. " " .. uid)
print("Please enter the username for the RuTorrent login")
io.write("Login: ")
io.flush()
local login = io.read()
os.execute("sudo htpasswd -c /etc/apache2/.htpasswd " .. login)


print("Restarting apache")
os.execute("sudo service apache2 restart >> /dev/null")
print("Starting rTorrent")
os.execute("screen -S rtorrent -fa -d -m rtorrent")


