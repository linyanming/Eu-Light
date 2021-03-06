--[[=============================================================================
    Lua Action Code

    Copyright 2016 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.actions = "2016.01.08"
end

-- TODO: Create a function for each action defined in the driver

function LUA_ACTION.TemplateVersion()
	TemplateVersion()
end



function LUA_ACTION.Sync()
     print("sync device")
     local devid = C4:GetDeviceID()
	local dest_id = C4:GetBoundProviderDevice(devid,1) 
	print("Id is " .. dest_id)
	C4:SendToDevice(dest_id,"SYNCDEV",{DEVICE_ID = devid})
end
