local _G, LibCommon = _G, LibCommon or {}
_G.LibCommon = LibCommon

-- Upvalued Lua globals
local format = string.format


-----------------------------
--- LibCommon.softassert(condition, message)
-- @param condition - result of a check that is expected to return a truthy value.
-- @param message - error message passed to  errorhandler()  if condition fails.
-- Continue execution even if condition fails, unlike  assert().
-- @return condition, (message if condition fails)
LibCommon.softassert = LibCommon.softassert  or function(ok, message)
	-- Readabable version with alternatives.
	return  ok,  not ok  and  (_G.geterrorhandler()(message) or message)  or  nil
	-- if ok then  return ok,nil  else  _G.geterrorhandler()(message) ; return ok,message  end
	-- if not ok then  _G.geterrorhandler()(message) ; return ok,message  else  return ok,nil  end
end

--[[ One-liner for copy-paste inclusion.
LibCommon.softassert = LibCommon.softassert  or function(ok, message)  return  ok,  not ok  and  (_G.geterrorhandler()(message) or message)  or  nil  end
LibCommon.softassert = LibCommon.softassert  or function(ok, message)  return ok, not ok and (_G.geterrorhandler()(message) or message) or nil  end
--]]


-----------------------------
--- LibCommon.softassertf( condition, messageFormat, formatParameter* )
-- @param condition - result of a check that is expected to return a truthy value.
-- @param messageFormat - error message passed to  string.format(), then  errorhandler()  if condition fails.
-- Continue execution even if condition fails, unlike  assert().
-- @return condition, (message if condition fails)
LibCommon.softassertf = LibCommon.softassertf  or function(ok, messageFormat, ...)
	if ok then  return ok,nil  end
	local message = format(messageFormat, ...)
  _G.geterrorhandler()(message)
	return ok,message
end

--[[ One-liner. Sort of.
LibCommon.softassertf = LibCommon.softassertf  or function(ok, message, ...)
	if ok then  return ok,nil  else  message = format(message, ...) ; _G.geterrorhandler()(message) ; return ok,message  end end
end
--]]


-----------------------------
-- Note about  errorhandler(message):
-- The builtin version called _ERRORMESSAGE() returns `message` (@see FrameXML/BasicControls.xml#_ERRORMESSAGE() ).
-- The following addon overrides do not follow this protocol and return nothing:
-- BugGrabber.lua#grabError(), Swatter.lua#OnErrorHandler, tekErr.lua
-- TradeSkillMaster/Core/ErrorHandler.lua#TSMErrorHandler()
-- Auctionator/AtrErrorInspector.lua#Atr_Error_Handler()
-- LUI/scripts/bugcatcher.lua#script.new()


