-- Change these settings if you want --
activationKey = 20	-- Default: Z	https://docs.fivem.net/game-references/controls/
---------------------------------------

-- Define the variable used to open/close the tab
local isEnabled = false
local isLoaded = true --false

msglist = {}

function toJSON(table)

	local function isArray(table)
		local max = 0
		local count = 0
		for k, v in pairs(table) do
			if type(k) == 'number' then
				if k > max then max = k end
				count = count + 1
			else
				return -1
			end
		end
		if max > count * 2 then
			return -1
		end
		return max
	end

	local function printValue(value)
		if value == nil or value == 'null' then
			value = 'null'
		elseif type(value) == 'number' or type(value) == 'boolean' then
			value = tostring(value)
		elseif type(value) == 'table' then
			value = toJSON(value)
		elseif type(value) == 'string' then
			value = '"'..value..'"'
		else
			value = '"'..tostring(value)..'"'
		end
		return value
	end

	local virgola = ''
	local s

	if isArray(table) > 0 then
		-- is array
		s = '['
		for key, value in ipairs(table) do
			s = s..virgola
			virgola = ','
			s = s..printValue(value)
		end
		s = s..']'
	else
		-- is object
		s = '{'
		for key, value in pairs(table) do
			s = s..virgola..'"'..key..'":'
			virgola = ','
			s = s..printValue(value)
		end
		s = s..'}'
	end

	return s
end

RegisterNetEvent("newMessage")
AddEventHandler("newMessage", function(newmsg, newlist)
	msglist = newlist
	if isEnabled then
		SendNUIMessage({ meta = "message", name = newmsg.name, msg = newmsg.msg })
	end
end)

RegisterNetEvent("getList")
AddEventHandler("getList", function(newlist)
	msglist = newlist
end)

function REQUEST_NUI_FOCUS(bool)
    SetNuiFocus(bool, bool) -- focus, cursor
    if bool == true then
		TriggerServerEvent("getList", msglist)
		Citizen.Wait(100)
        SendNUIMessage({meta = "open", msglist = toJSON(msglist)})
    else
        SendNUIMessage({meta = "close"})
    end
    return bool
end

RegisterNUICallback(
    "data-bus",
    function(data)
        if data.load then
            print("Loaded the page")
            isLoaded = true
        elseif data.hide then
            print("Hiding the page")
            SetNuiFocus(false, false)
			SendNUIMessage({meta = "close"})
            isEnabled = false
		elseif data.message then
			TriggerServerEvent("newMessage", {msg = data.msg}, msglist)
        end
    end
)

Citizen.CreateThread(
    function()
        local l = 0
        local timeout = false
        while not isLoaded do
            Citizen.Wait(0)
            l = l + 1
            if l > 500 then
                isLoaded = true --
                timeout = true
            end
        end

        if timeout == true then
            print("Failed to load nui...")
        end

        print("::The client lua for page loaded::")

        REQUEST_NUI_FOCUS(false)

        while true do
            if (IsControlJustPressed(0, activationKey)) and GetLastInputMethod( 0 ) then
				isEnabled = not isEnabled
                REQUEST_NUI_FOCUS(isEnabled)
                print("The page state is: " .. tostring(isEnabled))
                Citizen.Wait(0)
            end
            if (isEnabled) then
                local ped = GetPlayerPed(-1)
                DisableControlAction(0, 1, isEnabled) -- LookLeftRight
                DisableControlAction(0, 2, isEnabled) -- LookUpDown
                DisableControlAction(0, 24, isEnabled) -- Attack
                DisablePlayerFiring(ped, isEnabled) -- Disable weapon firing
                DisableControlAction(0, 142, isEnabled) -- MeleeAttackAlternate
                DisableControlAction(0, 106, isEnabled) -- VehicleMouseControlOverride
            end
            Citizen.Wait(0)
        end
    end
)

