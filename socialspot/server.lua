_version = "0.9"

maxMessagem = maxMessages - 1 -- Don't change this

local mslist = {}

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
			
		}
	else
		return nil
	end
end

RegisterServerEvent("getMyUser")
AddEventHandler("getMyUser", function()
	local src = source
	local name = getIdentity(source)
	local fullname = name.firstname .. " " .. name.lastname
	TriggerClientEvent("getMyUser", src, fullname)
end)
RegisterServerEvent("newMessage")
AddEventHandler("newMessage", function(newmsg, msglist)
	local name = ''
	local fullname = ''
	local uhandle = newmsg.handle
	if useESXIdentity then
		name = getIdentity(source)
		fullname = name.firstname .. " " .. name.lastname
		if not useSteamHandle then
			uhandle = fullname
			newmsg.handle = fullname
		end
	else
		fullname = GetPlayerName(source)
	end
	if #mslist < maxMessages then
		for count = #mslist, 1, -1 do
			local count1 = count + 1
			mslist[count1] = mslist[count]
			
		end
		mslist[1] = {name = fullname, msg = newmsg.msg, color = newmsg.color, handle = uhandle}
	else
		for count = maxMessagem, 1, -1 do
			local count1 = count + 1
			mslist[count1] = mslist[count]
		end
		mslist[1] = {name = fullname, msg = newmsg.msg, color = newmsg.color, handle = uhandle}
	end
	newmsg.name = fullname
	TriggerClientEvent("newMessage", -1, newmsg, mslist)
end)

RegisterServerEvent("newPMessage")
AddEventHandler("newPMessage", function(newpmsg)
	local src = source
	local name = getIdentity(source)
	local fullname = name.firstname .. " " .. name.lastname
	newpmsg.name = fullname
	TriggerClientEvent("newPMessage", newpmsg.to, newpmsg)
end)

RegisterServerEvent("getList")
AddEventHandler("getList", function()
	TriggerClientEvent("getList", source, mslist)
end)

RegisterServerEvent("getUsers")
AddEventHandler("getUsers", function(users)
	local src = source
	local players = {}
	local ptable = users
	local fullname = ''
	for _, i in ipairs(ptable) do
		if useESXIdentity then
			local name = getIdentity(i[1])
			fullname = name.firstname .. " " .. name.lastname
		else
			fullname = GetPlayerName(i[1])
		end
		table.insert(players, {i[1], fullname})
	end
	TriggerClientEvent("getUsers", src, players)
end)

print('\n\27[104;39m> SocialSpot <\27[0;94m')
if autoupdatever == true then
print("Checking For Updates...")
PerformHttpRequest("https://textuploader.com/15d0x/raw", function(err, rText, headers)
		if rText > _version then
			print("\n\nAn update is available!\nDownloading latest release...")
			os.execute("start https://github.com/How-Bout-No/socialspot/archive/master.zip")
		else
			print("You are up to date\27[0m")
		end
end, "GET", "", {table = nil})
else
print("Automatic updates are disabled.")
print("\27[0m")
end