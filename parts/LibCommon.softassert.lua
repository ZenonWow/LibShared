local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME]
assert(LibCommon and LibCommon.Define, 'Include "LibCommon.Define.lua" before.')

-- GLOBALS:
-- Used from _G:  geterrorhandler
-- Used from LibCommon:
-- Exported to LibCommon:  softassert, softassertf

-- Upvalued Lua globals
local format = string.format


-----------------------------
-- TODO
-- reporterror(): Report error without failing.
LibCommon.Define.reporterror = function(errorMessage)
	CallbackHandler.errorsReported = CallbackHandler.errorsReported or {}
	if  CallbackHandler.errorsReported[errorMessage]  then  return false  end
	CallbackHandler.errorsReported[errorMessage] = _G.time()
	local err = _G.geterrorhandler()(errorMessage)
	-- Avoiding tailcall: reporterror() function would show up as "?" in stacktrace, making it harder to understand.
	return err
end


-----------------------------
--- LibCommon.softassert(condition, message)
-- Check for unexpected values or anomalies without crashing. Reports anomaly, then goes on.
-- @param condition - result of a check that is expected to return a truthy value.
-- @param message - error message passed to  errorhandler()  if condition fails.
-- Continue execution even if condition fails, unlike  assert().
-- @return condition, (message if condition fails)
--
LibCommon.Define.softassert = function(ok, message)
	-- Readabable version with alternatives.
	return  ok,  not ok  and  (_G.geterrorhandler()(message) or message)  or  nil
	-- if ok then  return ok,nil  else  _G.geterrorhandler()(message) ; return ok,message  end
	-- if not ok then  _G.geterrorhandler()(message) ; return ok,message  else  return ok,nil  end
end

--[[ One-liner for copy-paste inclusion. Pick your style.
LibCommon.Define.softassert = function(ok, message)  return  ok,  not ok  and  (_G.geterrorhandler()(message) or message)  or  nil  end
LibCommon.Define.softassert = function(ok, message)  return ok, not ok and (_G.geterrorhandler()(message) or message) or nil  end
--]]


-----------------------------
--- LibCommon.softassertf( condition, messageFormat, formatParameter* )
-- @param condition - result of a check that is expected to return a truthy value.
-- @param messageFormat - error message passed to  string.format(), then  errorhandler()  if condition fails.
-- Continue execution even if condition fails, unlike  assert().
-- @return condition, (message if condition fails)
--
LibCommon.Define.softassertf = function(ok, messageFormat, ...)
	if ok then  return ok,nil  end
	local message = format(messageFormat, ...)
  _G.geterrorhandler()(message)
	return ok,message
end

--[[ One-liner for copy-paste inclusion. Sort of.
LibCommon.Define.softassertf = function(ok, message, ...)
	if ok then  return ok,nil  else  message = format(message, ...) ; _G.geterrorhandler()(message) ; return ok,message  end end
end
--]]


-----------------------------
-- Note about  errorhandler(message):
-- The builtin version called _ERRORMESSAGE() returns `message` (@see FrameXML/BasicControls.xml#_ERRORMESSAGE() ).
-- The following addon overrides do not follow this protocol and return nothing:
-- BugGrabber.lua#grabError()
-- Swatter.lua#OnErrorHandler
-- tekErr.lua
-- TradeSkillMaster/Core/ErrorHandler.lua#TSMErrorHandler()
-- Auctionator/AtrErrorInspector.lua#Atr_Error_Handler()
-- LUI/scripts/bugcatcher.lua#script.new()


