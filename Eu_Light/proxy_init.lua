--[[=============================================================================
    Initialization Functions

    Copyright 2017 Control4 Corporation. All Rights Reserved.
===============================================================================]]
require "light.light_proxy_class"
require "light.light_proxy_commands"
require "light.light_proxy_notifies"


DEVICE_ADDR = {}
-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.proxy_init = "2017.01.13"
end

function ON_DRIVER_EARLY_INIT.proxy_init()
	-- declare and initialize global variables
	C4:AllowExecute(false)
end

function ON_DRIVER_INIT.proxy_init()

	gLightProxy = LightProxy:new(DEFAULT_PROXY_BINDINGID)
end

function ON_DRIVER_LATEINIT.proxy_init()
    local cmd = {CHANNEL = gLightProxy._Channel}
    local devid = C4:GetDeviceID()
    local id = C4:GetBoundProviderDevice(devid,CHANNEL_BINDING_ID) 
    if(id ~= 0) then
	   C4:SendToDevice(id,"REQLEVEL",cmd)
    end
end


