local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
-- local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:  geterrorhandler  (might be hooked/modified)
-- Used from LibCommon:
-- Exported to LibCommon:  softassert, asserttype, assertf, softassertf

-- Upvalued Lua globals
local format,error,type = string.format,error,type


-----------------------------
--- errorf(...)     = assertf(false, ...)
--- softerror(...)  = softassert(false, ...)
--- softerrorf(...) = softassertf(false, ...)



-----------------------------
--- LibCommon. softassert(condition, message):  Report error, then continue execution, _unlike_ assert().
-- Check for unexpected values or anomalies without crashing. Reports anomaly, then continues your function, unlike assert().
-- @param condition - result of a check that is expected to return a truthy value.
-- @param message - error message passed to  errorhandler()  if condition fails.
-- @return condition  [, garbage] (condition or message returned by builtin errorhandler _ERRORMESSAGE, or nothing returned by BugGrabber's errorhandler )
--
-- Copy-paste these 4 lines to your file to include without depending on LibCommon being loaded.
--- LibCommon. softassert(condition, message):  Report error, then continue execution, _unlike_ assert().
local LibCommon = _G.LibCommon or {}  ;  _G.LibCommon = LibCommon
LibCommon.softassert = LibCommon.softassert  or  function(ok, message)  return ok, ok or _G.geterrorhandler()(message)  end
local softassert = LibCommon.softassert

-- You can use the return value to make compact statements:
--  local name = softassert(namestorage[dataobj], "Missing name of dataobj.") or "?"
--


-----------------------------
--- LibCommon. softassertf( condition, messageFormat, formatParameter...):  Report error, then continue execution, _unlike_ assert(). Formatted error message.
-- @param condition - result of a check that is expected to return a truthy value.
-- @param messageFormat - error message passed to  string.format(), then  errorhandler()  if condition fails.
-- @return condition, (message if condition fails)
--
LibCommon.softassertf = LibCommon.softassertf  or  function(ok, messageFormat, ...)
	if ok then  return ok,nil  end  ;  local message = format(messageFormat, ...)  ;  _G.geterrorhandler()(message)  ;  return ok,message
end


-----------------------------
--- LibCommon. asserttype(value, typename, [messagePrefix]):  Raises error (stops execution) if value's type is not the expected `typename`.
-- @param value - to check for type.
-- @param typename (string) - name of expected type.
-- @param messagePrefix (string/nil) - optional error message prefixed to:  "<typename> expected, got <type>"
--
LibCommon.asserttype = LibCommon.asserttype  or  function(value, typename, messagePrefix, calldepth)
	if type(value)~=typename then  error( (messagePrefix or "")..typename.." expected, got "..type(value), (calldepth or 1)+1 )  end
end


-----------------------------
--- LibCommon. asserttypeOrNil(value, typename, [messagePrefix]):  Raises error (stops execution) if value's type is not the expected `typename` and value is not nil.
-- @param value - to check for type.
-- @param typename (string) - name of expected type.
-- @param messagePrefix (string/nil) - optional error message prefixed to:  "<typename> expected, got <type>"
--
LibCommon.asserttypeOrNil = LibCommon.asserttypeOrNil  or  function(value, typename, messagePrefix, calldepth)
	if nil~=value and type(value)~=typename then  error( (messagePrefix or "")..typename.." expected, got "..type(value), (calldepth or 1)+1 )  end
end


-----------------------------
--- LibCommon. asserttypeOrFalse(value, typename, [messagePrefix]):  Raises error (stops execution) if value's type is not the expected `typename` and value is not nil or false.
-- @param value - to check for type.
-- @param typename (string) - name of expected type.
-- @param messagePrefix (string/nil) - optional error message prefixed to:  "<typename> expected, got <type>"
--
LibCommon.asserttypeOrFalse = LibCommon.asserttypeOrFalse  or  function(value, typename, messagePrefix, calldepth)
	if value and type(value)~=typename then  error( (messagePrefix or "")..typename.." expected, got "..type(value), (calldepth or 1)+1 )  end
end


-----------------------------
--- LibCommon. assertf(condition, messageFormat, formatParameter...):  Raises error (stops execution) if condition fails. Formatted error message.
-- @param condition - result of a check that is expected to return a truthy value.
-- @param messageFormat - error message passed to  string.format(), then  error()  if condition fails.
-- Stops execution if condition fails, like  assert().
--
LibCommon.assertf = LibCommon.assertf  or  function(ok, messageFormat, ...)  if not ok then  error( format(messageFormat, ...) )  end  end
LibCommon.assertnf = LibCommon.assertnf  or  function(ok, calldepth, messageFormat, ...)  if not ok then  error( format(messageFormat, ...), calldepth+1 )  end  end





-- Alternatives:
--[[
LibCommon.softassert = LibCommon.softassert or  function(ok, message)
	-- return  ok,  ok  or  (_G.geterrorhandler()(message) or message)  or  nil
	-- if ok then  return ok,nil  else  _G.geterrorhandler()(message) ; return ok,message  end
	-- if not ok then  _G.geterrorhandler()(message) ; return ok,message  else  return ok,nil  end
	-- if not ok then  _G.geterrorhandler()(message) ; return ok,message  else  return ok,nil  end
	-- if not ok then  _G.geterrorhandler()(message)  end ; return ok, ok and message or nil  end
	-- if not ok then  _G.geterrorhandler()(message)  end ; return ok  end
	-- return ok, not ok and _G.geterrorhandler()(message)  end
	-- return ok, ( ok or _G.geterrorhandler()(message) ) and nil  end
	-- return ok, ok or _G.geterrorhandler()(message)  end
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


