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
--    self._Toggle = false
    self._LightStatus = false
    self._MsgTable = {}
    self._SendTable = {}
    self._MsgPos = 1
    self._SendPos = 1
    self._CmdSync = false
    self._DeviceStatus = false
    
    self._Timer = CreateTimer("SEND_DATA", 600, "MILLISECONDS", TimerCallback, true, nil)
    self._CmdCnfTimer = CreateTimer("CMD_CONFIRM", 3, "SECONDS", CmdCnfTimerCallback, false, nil)

end

function CmdCnfTimerCallback()
    LogTrace("confirm fail")
    gLightProxy:SendCommandToDeivce(gLightProxy._SendTable[gLightProxy._SendPos])
    gLightProxy._SendTable[gLightProxy._SendPos] = ""
    gLightProxy._CmdSync = false
--    if(gLightProxy._DeviceStatus == true) then
    NOTIFY.OFFLINE(gLightProxy._BindingID)
--    end
end

function TimerCallback()
 --    LogTrace("TimerCallback")
	if(gLightProxy._MsgTable[gLightProxy._MsgPos] ~= nil and gLightProxy._MsgTable[gLightProxy._MsgPos] ~= "" and gLightProxy._CmdSync ~= true) then
	    gLightProxy._SendTable[gLightProxy._SendPos] = gLightProxy._MsgTable[gLightProxy._MsgPos]
	    gLightProxy:SendCommandToDeivce(gLightProxy._SendTable[gLightProxy._SendPos])
	    gLightProxy._MsgTable[gLightProxy._MsgPos] = ""
	    gLightProxy._CmdSync = true
	    StartTimer(gLightProxy._CmdCnfTimer)
     else
	   if(gLightProxy._CmdSync ~= true) then
		  KillTimer(gLightProxy._Timer)
	   end
	end
end

function LightProxy:SendCommandToDeivce(command)
    if(command == "ON") then
	   self:prx_ON({})
    elseif(command == "OFF") then
	   self:prx_OFF({})
    else
	   self:prx_TOGGLE({})
    end
end

function LightProxy:AddToQueue(command)
    LogTrace("LightProxy:AddToQueue")
    self._MsgTable[self._MsgPos] = command
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
    LogTrace("LightProxy:prx_ON")
    tParams = tParams or {}
    local cmd = {CHANNEL = self._Channel,LEVEL = 100}
    local devid = C4:GetDeviceID()
    local id = C4:GetBoundProviderDevice(devid,CHANNEL_BINDING_ID) 
    C4:SendToDevice(id,"SETLEVEL",cmd)
    C4:SendToDevice(id,"REQLEVEL",cmd)


end

function LightProxy:prx_OFF(tParams)
    LogTrace("LightProxy:prx_OFF")
    tParams = tParams or {}
    local cmd = {CHANNEL = self._Channel,LEVEL = 0}
    local devid = C4:GetDeviceID()
    local id = C4:GetBoundProviderDevice(devid,CHANNEL_BINDING_ID)
    C4:SendToDevice(id,"SETLEVEL",cmd)
    C4:SendToDevice(id,"REQLEVEL",cmd)
end

function LightProxy:prx_TOGGLE(tParams)
    tParams = tParams or {}
    if(self._LightStatus) then
	   self:prx_OFF({})
    else
	   self:prx_ON({})
    end
--[[
    local cmd = {CHANNEL = self._Channel}
    local devid = C4:GetDeviceID()
    local id = C4:GetBoundProviderDevice(devid,CHANNEL_BINDING_ID) 
    print("Id is " .. id)
    C4:SendToDevice(id,"REQLEVEL",cmd)
    self._Toggle = true
    ]]
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