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
	   gLightProxy:AddToQueue("ON")
	   gLightProxy:SendCommandToDeivce(gLightProxy._MsgTable[gLightProxy._MsgSendPos])
	   StartTimer(gLightProxy._Timer)
	   gLightProxy._CmdSync = true
	   StartTimer(gLightProxy._CmdCnfTimer)
    end
end

function PRX_CMD.OFF(idBinding, tParams)
    if(TimerStarted(gLightProxy._Timer)) then
	   gLightProxy:AddToQueue("OFF")
    else
	   gLightProxy:AddToQueue("OFF")
	   gLightProxy:SendCommandToDeivce(gLightProxy._MsgTable[gLightProxy._MsgSendPos])
	   StartTimer(gLightProxy._Timer)
	   gLightProxy._CmdSync = true
	   StartTimer(gLightProxy._CmdCnfTimer)
    end
end

function PRX_CMD.TOGGLE(idBinding, tParams)
    if(TimerStarted(gLightProxy._Timer)) then
	   gLightProxy:AddToQueue("TOGGLE")
    else
	   gLightProxy:AddToQueue("TOGGLE")
	   gLightProxy:SendCommandToDeivce(gLightProxy._MsgTable[gLightProxy._MsgSendPos])
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

function UI_REQ.GET_CONNECTED_STATE(tParams)
     LogTrace("UI_REQ.GET_CONNECTED_STATE")
	LogTrace(tParams)
	return "<ONLINE_CHANGE>true</ONLINE_CHANGED>"
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