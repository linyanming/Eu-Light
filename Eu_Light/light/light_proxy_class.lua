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
    self._MsgPos = 1
    self._MsgSendPos = 1
    self._MsgTableMax = 100
    self._CmdSync = false
    self._Timer = CreateTimer("SEND_DATA", 600, "MILLISECONDS", TimerCallback, true, nil)
    self._CmdCnfTimer = CreateTimer("CMD_CONFIRM", 600, "MILLISECONDS", CmdCnfTimerCallback, false, nil)

end

function CmdCnfTimerCallback()
    LogTrace("confirm fail")
    gLightProxy:SendCommandToDeivce(gLightProxy._MsgTable[gLightProxy._MsgSendPos])
    gLightProxy._MsgTable[gLightProxy._MsgSendPos] = ""
    if(gLightProxy._MsgSendPos == gLightProxy._MsgTableMax) then
	   gLightProxy._MsgSendPos = 1
    else
	   gLightProxy._MsgSendPos = gLightProxy._MsgSendPos + 1
    end
    gLightProxy._CmdSync = false
end

function TimerCallback()
 --    LogTrace("TimerCallback")
	if(gLightProxy._MsgTable[gLightProxy._MsgSendPos] ~= nil and gLightProxy._MsgTable[gLightProxy._MsgSendPos] ~= "" and gLightProxy._CmdSync ~= true) then
	    gLightProxy:SendCommandToDeivce(gLightProxy._MsgTable[gLightProxy._MsgSendPos])
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
    if(self._MsgPos == self._MsgTableMax) then
	   self._MsgPos = 1
    else
	   self._MsgPos = self._MsgPos + 1
    end
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