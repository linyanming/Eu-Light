--[[=============================================================================
    Light Proxy Class

    Copyright 2018 Hiwise Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.light_proxy_class = "2018.05.23"
end

LightProxy = inheritsFrom(nil)

function LightProxy:construct(bindingID)
	-- member variables
	self._BindingID = bindingID

	self:Initialize()

end

function LightProxy:Initialize()
	-- create and initialize member variables
    self._Channel = Properties["Channel"]
    self._Toggle = false
end

function LightProxy:UpdateProperty(channelid)
    C4:UpdateProperty("Channel",channelid)
    self._Channel = channelid
    local cmd = {CHANNEL = self._Channel}
    local devid = C4:GetDeviceID()
    local id = C4:GetBoundProviderDevice(devid,CHANNEL_BINDING_ID) 
    print("Id is " .. id)
    C4:SendToDevice(id,"REQLEVEL",cmd)
end

--[[=============================================================================
    LightProxy Proxy Commands(PRX_CMD)
===============================================================================]]
function LightProxy:prx_ON(tParams)
    tParams = tParams or {}
    local cmd = {CHANNEL = self._Channel,LEVEL = 100}
    local devid = C4:GetDeviceID()
    local id = C4:GetBoundProviderDevice(devid,CHANNEL_BINDING_ID) 
    print("Id is " .. id)
    C4:SendToDevice(id,"SETLEVEL",cmd)
    C4:SendToDevice(id,"REQLEVEL",cmd)
end

function LightProxy:prx_OFF(tParams)
    tParams = tParams or {}
    local cmd = {CHANNEL = self._Channel,LEVEL = 0}
    local devid = C4:GetDeviceID()
    local id = C4:GetBoundProviderDevice(devid,CHANNEL_BINDING_ID)
    print("Id is " .. id)
    C4:SendToDevice(id,"SETLEVEL",cmd)
    C4:SendToDevice(id,"REQLEVEL",cmd)
end

function LightProxy:prx_TOGGLE(tParams)
    tParams = tParams or {}
    local cmd = {CHANNEL = self._Channel}
    local devid = C4:GetDeviceID()
    local id = C4:GetBoundProviderDevice(devid,CHANNEL_BINDING_ID) 
    print("Id is " .. id)
    C4:SendToDevice(id,"REQLEVEL",cmd)
    self._Toggle = true
end


function LightProxy:prx_BUTTON_ACTION(tParams)
    tParams = tParams or {}
    local action = tonumber(tParams["ACTION"])
    if(action == 2) then
	   self:prx_TOGGLE({})
    end
    
end

function LightProxy:prx_GET_CONNECTED_STATE()
    local cmd = {CHANNEL = self._Channel}
    local devid = C4:GetDeviceID()
    local id = C4:GetBoundProviderDevice(devid,CHANNEL_BINDING_ID) 
    print("Id is " .. id)
    C4:SendToDevice(id,"REQLEVEL",cmd)
end