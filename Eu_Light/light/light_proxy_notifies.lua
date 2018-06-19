--[[=============================================================================
    Notification Functions

    Copyright 2016 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.keypad_proxy_notifies = "2018.05.23"
end

function NOTIFY.ON(bindingID)
     LogTrace("NOTIFY.ON")
	print("bindingID = ".. bindingID) 
     SendNotify("LIGHT_LEVEL", 100, bindingID)
	gLightProxy._LightStatus = true
end

function NOTIFY.OFF(bindingID)
     LogTrace("NOTIFY.OFF")
	print("bindingID = ".. bindingID) 
     SendNotify("LIGHT_LEVEL", 0, bindingID)
	gLightProxy._LightStatus = false
end

--[[
function NOTIFY.PROPERTY_DEFAULTS(bindingID, tPropertyDefaults)
	LogTrace("NOTIFY.PROPERTY_DEFAULTS")

	SendNotify("PROPERTY_DEFAULTS", tPropertyDefaults, bindingID)
end
]]
