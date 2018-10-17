--[[=============================================================================
    Command Functions Received From Proxy to the Camera Driver

    Copyright 2018 Hiwise Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.keypad_proxy_commands = "2018.05.23"
end

function PRX_CMD.ON(idBinding, tParams)
    if(TimerStarted(gLightProxy._Timer)) then
	   gLightProxy:AddToQueue("ON")
    else
	   gLightProxy._SendTable[gLightProxy._SendPos] = "ON"
	   gLightProxy:SendCommandToDeivce(gLightProxy._SendTable[gLightProxy._SendPos])
	   StartTimer(gLightProxy._Timer)
	   gLightProxy._CmdSync = true
	   StartTimer(gLightProxy._CmdCnfTimer)
    end
end

function PRX_CMD.OFF(idBinding, tParams)
    if(TimerStarted(gLightProxy._Timer)) then
	   gLightProxy:AddToQueue("OFF")
    else
	   gLightProxy._SendTable[gLightProxy._SendPos] = "OFF"
	   gLightProxy:SendCommandToDeivce(gLightProxy._SendTable[gLightProxy._SendPos])
	   StartTimer(gLightProxy._Timer)
	   gLightProxy._CmdSync = true
	   StartTimer(gLightProxy._CmdCnfTimer)
    end
end

function PRX_CMD.TOGGLE(idBinding, tParams)
    if(TimerStarted(gLightProxy._Timer)) then
	   gLightProxy:AddToQueue("TOGGLE")
    else
	   gLightProxy._SendTable[gLightProxy._SendPos] = "TOGGLE"
	   gLightProxy:SendCommandToDeivce(gLightProxy._SendTable[gLightProxy._SendPos])
	   StartTimer(gLightProxy._Timer)
	   gLightProxy._CmdSync = true
	   StartTimer(gLightProxy._CmdCnfTimer)
    end
end

function PRX_CMD.BUTTON_ACTION(idBinding, tParams)
	gLightProxy:prx_BUTTON_ACTION(tParams)
end

function PRX_CMD.GET_CONNECTED_STATE(idBinding, tParams)
    LogTrace("PRX_CMD.GET_CONNECTED_STATE")
    LogTrace(tParams)
    gLightProxy:prx_GET_CONNECTED_STATE()
end

function PRX_CMD.GET_LIGHT_LEVEL(idBinding, tParams)
    LogTrace("PRX_CMD.GET_LIGHT_LEVEL")
    LogTrace(tParams)
    if(gLightProxy._LightStatus) then
        NOTIFY.ON(gLightProxy._BindingID)
    else
        NOTIFY.OFF(gLightProxy._BindingID)
    end
end


function PRX_CMD.ACTIVATE_SCENE(idBinding, tParams)
    LogTrace("PRX_CMD.ACTIVATE_SCENE")
    LogTrace(tParams)
    local SCENE_ID = tonumber(tParams["SCENE_ID"]) or -1
    if (SCENE_ID == -1) then return end
    local scene = gScenes[SCENE_ID] or {}
    local elements = scene.ELEMENTS or ""
    if (scene.PARSED_ELEMENTS == nil) then
        if (elements == "") then return end
        local pe = {}
        for element in elements:gfind("<element>(.-)</element>") do
            local _, _, strDelay = element:find("<delay>(.-)</delay>")
            local _, _, strRate  = element:find("<rate>(.-)</rate>")
            local _, _, strLevel = element:find("<level>(.-)</level>")
            table.insert(pe, {delay = tonumber(strDelay) or 0, rate = tonumber(strRate) or 0, level = tonumber(strLevel) or 0})
        end
        scene.PARSED_ELEMENTS = pe
    end
    C4:InvalidateState()
    local delay = 0
    for k,v in ipairs(scene.PARSED_ELEMENTS) do
        print("Element: delay: " .. v.delay .. " level: " .. v.level)
        delay = delay + v.delay or 0
        if(delay == 0) then
            if(v.level == 0) then
                PRX_CMD.OFF(gLightProxy._BindingID,{})
            else
                PRX_CMD.ON(gLightProxy._BindingID,{})
            end
        else
            C4:SetTimer(delay, function() 
                if(v.level == 0) then
                    PRX_CMD.OFF(gLightProxy._BindingID,{})
                else
                    PRX_CMD.ON(gLightProxy._BindingID,{})
                end
            end)
        end
    end 
end

function PRX_CMD.PUSH_SCENE(idBinding, tParams)
    LogTrace("PRX_CMD.PUSH_SCENE")
    LogTrace(tParams)
    local SCENE_ID = tonumber(tParams["SCENE_ID"])
    gScenes[SCENE_ID] = tParams
    C4:InvalidateState()
end

function PRX_CMD.REMOVE_SCENE(idBinding, tParams)
    LogTrace("PRX_CMD.REMOVE_SCENE")
    LogTrace(tParams)
    local SCENE_ID = tonumber(tParams["SCENE_ID"]) or -1
    gScenes[SCENE_ID] = nil
    C4:InvalidateState()
end

function PRX_CMD.ALL_SCENES_PUSHED(idBinding, tParams)
    LogTrace("PRX_CMD.ALL_SCENES_PUSHED")
    LogTrace(tParams)
    C4:InvalidateState()
end

function PRX_CMD.RAMP_SCENE_DOWN(idBinding, tParams)
    LogTrace("PRX_CMD.RAMP_SCENE_DOWN")
    LogTrace(tParams)
    
end

function PRX_CMD.RAMP_SCENE_UP(idBinding, tParams)
    LogTrace("PRX_CMD.RAMP_SCENE_UP")
    LogTrace(tParams)
    
end

function PRX_CMD.STOP_RAMP_SCENE(idBinding, tParams)
    LogTrace("PRX_CMD.STOP_RAMP_SCENE")
    LogTrace(tParams)
    
end


function PRX_CMD.CLEAR_ALL_SCENES(idBinding, tParams)
    LogTrace("PRX_CMD.CLEAR_ALL_SCENES")
    LogTrace(tParams)
    gScenes = {}
    C4:InvalidateState()
end


function UI_REQ.GET_CONNECTED_STATE(tParams)
    LogTrace("UI_REQ.GET_CONNECTED_STATE")
	LogTrace(tParams)
	C4:SendDataToUI("<ONLINE_CHANGED>true</ONLINE_CHANGED>")
--	return "<ONLINE_CHANGE>true</ONLINE_CHANGED>"
end

--[[
function PRX_CMD.SET_ADDRESS(idBinding, tParams)
	gCameraProxy:prx_SET_ADDRESS(tParams)
end

function PRX_CMD.SET_HTTP_PORT(idBinding, tParams)
	gCameraProxy:prx_SET_HTTP_PORT(tParams)
end

function PRX_CMD.SET_RTSP_PORT(idBinding, tParams)
	gCameraProxy:prx_SET_RTSP_PORT(tParams)
end

function PRX_CMD.SET_AUTHENTICATION_REQUIRED(idBinding, tParams)
	gCameraProxy:prx_SET_AUTHENTICATION_REQUIRED(tParams)
end

function PRX_CMD.SET_AUTHENTICATION_TYPE(idBinding, tParams)
	gCameraProxy:prx_SET_AUTHENTICATION_TYPE(tParams)
end

function PRX_CMD.SET_USERNAME(idBinding, tParams)
	gCameraProxy:prx_SET_USERNAME(tParams)
end

function PRX_CMD.SET_PASSWORD(idBinding, tParams)
	gCameraProxy:prx_SET_PASSWORD(tParams)
end

function PRX_CMD.SET_PUBLICLY_ACCESSIBLE(idBinding, tParams)
	gCameraProxy:prx_SET_PUBLICLY_ACCESSIBLE(tParams)
end

function PRX_CMD.PAN_LEFT(idBinding, tParams)
	gCameraProxy:prx_PAN_LEFT()
end

function PRX_CMD.PAN_RIGHT(idBinding, tParams)
	gCameraProxy:prx_PAN_RIGHT()
end

function PRX_CMD.PAN_SCAN(idBinding, tParams)
	gCameraProxy:prx_PAN_SCAN()
end

function PRX_CMD.TILT_UP(idBinding, tParams)
	gCameraProxy:prx_TILT_UP()
end

function PRX_CMD.TILT_DOWN(idBinding, tParams)
	gCameraProxy:prx_TILT_DOWN()
end

function PRX_CMD.TILT_SCAN(idBinding, tParams)
	gCameraProxy:prx_TILT_SCAN()
end

function PRX_CMD.ZOOM_IN(idBinding, tParams)
	gCameraProxy:prx_ZOOM_IN()
end

function PRX_CMD.ZOOM_OUT(idBinding, tParams)
	gCameraProxy:prx_ZOOM_OUT()
end

function PRX_CMD.HOME(idBinding, tParams)
	gCameraProxy:prx_HOME()
end

function PRX_CMD.MOVE_TO(idBinding, tParams)
	gCameraProxy:prx_MOVE_TO(tParams)
end

function PRX_CMD.PRESET(idBinding, tParams)
	gCameraProxy:prx_PRESET(tParams)
end


-- UI Requests
function UI_REQ.GET_SNAPSHOT_QUERY_STRING(tParams)
	return gCameraProxy:req_GET_SNAPSHOT_QUERY_STRING(tParams)
end

function UI_REQ.GET_MJPEG_QUERY_STRING(tParams)
	return gCameraProxy:req_GET_MJPEG_QUERY_STRING(tParams)
end

function UI_REQ.GET_RTSP_H264_QUERY_STRING(tParams)
	return gCameraProxy:req_GET_RTSP_H264_QUERY_STRING(tParams)
end

]]
