--[[=============================================================================
    Copyright 2016 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.device_specific_commands = "2016.01.08"
end

--[[=============================================================================
    ExecuteCommand Code

    Define any functions for device specific commands (EX_CMD.<command>)
    received from ExecuteCommand that need to be handled by the driver.
===============================================================================]]
--function EX_CMD.NEW_COMMAND(tParams)
--	LogTrace("EX_CMD.NEW_COMMAND")
--	LogTrace(tParams)
--end

function EX_CMD.LIGHTREPORT(tParams)
	LogTrace("EX_CMD.LIGHTREPORT")
	LogTrace(tParams)
     local level = tParams["LEVEL"]
    if(level == "0") then
	   NOTIFY.OFF(gLightProxy._BindingID)
    else
	   NOTIFY.ON(gLightProxy._BindingID)
    end
--    if(gLightProxy._DeviceStatus == false) then
        NOTIFY.ONLINE(gLightProxy._BindingID)
--    end
    if(gLightProxy._CmdSync == true) then
	   if(TimerStarted(gLightProxy._CmdCnfTimer)) then
		  KillTimer(gLightProxy._CmdCnfTimer)
		  gLightProxy._SendTable[gLightProxy._SendPos] = ""
		  
	   end
	   gLightProxy._CmdSync = false
    end
end

function EX_CMD.CHANNELID(tParams)
    LogTrace("EX_CMD.LIGHTREPORT")
	LogTrace(tParams)
	local id = tonumber(tParams["CHID"])
	gLightProxy:UpdateProperty(id)
     
end
