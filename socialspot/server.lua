-- Change these settings if you want --
maxMessages = 15		-- Amount of messages to store server side
autoupdatever = false	-- Automatically check and download updates
---------------------------------------

_version = "0.9"

maxMessagem = maxMessages - 1 -- Don't change this

local mslist = {}

RegisterServerEvent("newMessage")
AddEventHandler("newMessage", function(newmsg, msglist)
	mslist = msglist
	if #mslist < maxMessages then
		for count = #mslist, 1, -1 do
			local count1 = count + 1
			mslist[count1] = mslist[count]
		end
		mslist[1] = {name = GetPlayerName(source), msg = newmsg.msg}
	else
		for count = maxMessagem, 1, -1 do
			local count1 = count + 1
			mslist[count1] = mslist[count]
		end
		mslist[1] = {name = GetPlayerName(source), msg = newmsg.msg}
	end
	newmsg.name = GetPlayerName(source)
	TriggerClientEvent("newMessage", -1, newmsg, mslist)
end)

RegisterServerEvent("newPMessage")
AddEventHandler("newPMessage", function(newpmsg)
	newpmsg.name = GetPlayerName(source)
	TriggerClientEvent("newPMessage", newpmsg.to, newpmsg)
end)

RegisterServerEvent("getList")
AddEventHandler("getList", function()
	TriggerClientEvent("getList", source, mslist)
end)

RegisterServerEvent("getName")
AddEventHandler("getName", function()
	TriggerClientEvent("getName", source, GetPlayerName(source))
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
