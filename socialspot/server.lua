--Config
autoupdatever = true  -- automatically detect and fetch the download for the latest version of this script?
--End Config

--Startup
print('\n\27[104m> SocialSpot <\27[0m')
_version = "0.1"
print("\27[94mChecking For Updates...")
PerformHttpRequest("https://textuploader.com/15d0x/raw", function(err, rText, headers)
if rText <= _version then
	print("You are up to date")
end
end, "GET", "", {table = nil})
--End Startup


-- Change these settings if you want --
maxMessages = 15
---------------------------------------

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

RegisterServerEvent("getList")
AddEventHandler("getList", function()
	print(GetPlayerName(source))
	TriggerClientEvent("getList", source, mslist)
end)

--AutoUpdater
if autoupdatever == true then
PerformHttpRequest("https://textuploader.com/15d0x/raw", function(err, rText, headers)
		if rText > _version then
			print("\n\nOutdated Version!\nDownloading latest release...")
			os.execute("start https://github.com/How-Bout-No/socialspot/archive/master.zip")
		end
		print("\27[0m")
end, "GET", "", {table = nil})
else
print("Automatic updates are disabled.")
print("\27[0m")
end
--End AutoUpdater