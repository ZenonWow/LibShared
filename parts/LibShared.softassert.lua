local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  geterrorhandler  (might be hooked/modified)
-- Used from LibShared:
-- Exported to LibShared:  softassert, asserttype, assertf, softassertf

-- Upvalued Lua globals:
local format,error,type = string.format,error,type


--[[ Copy-paste import code:
asserttype(inputFields, 'table', "Usage: LDB:NewDataObject(name, dataobject):  `dataobject` - ")
--]]


-----------------------------
--- errorf(...)     = assertf(false, ...)
--- softerror(...)  = softassert(false, ...)
--- softerrorf(...) = softassertf(false, ...)



-----------------------------
--- LibShared. errorhandler(errorMessage):  Report error. Calls _G.geterrorhandler(), without tailcall to generate readable stacktrace.
-- Allows hooking G.geterrorhandler(): the returned errorhandler is not saved.
-- Calls through errorhandler() local, thus the errorhandler() function name is printed in stacktrace, not just a line number.
-- Avoids tailcall and returns the errorMessage like the builtin errorhandler with `or errorMessage`.
--
LibShared.errorhandler = LibShared.errorhandler or  function(errorMessage)  local errorhandler = G.geterrorhandler() ; return errorhandler(errorMessage) or errorMessage  end
local errorhandler = LibShared.errorhandler



-----------------------------
--- LibShared. softerror(errorMessage, stackDepth):  Report error, with the line causing it, `stackDepth` levels higher up in the callstack.
-- @param  stackDepth  -1 smaller than the 2nd parameter to error(). 0 == where softerror() is called.
-- Calls _G.geterrorhandler(), without tailcall to generate readable stacktrace.
-- Allows hooking G.geterrorhandler(): the returned errorhandler is not saved.
-- Calls through errorhandler() local, thus the errorhandler() function name is printed in stacktrace, not just a line number.
-- Avoids tailcall and returns the errorMessage like the builtin errorhandler with `or errorMessage`.
--
LibShared.softerror = LibShared.softerror or  function(errorMessage, stackDepth)
  local errorhandler, stackLine = G.geterrorhandler(), G.debugstack( (stackDepth or 0)+2, 1, 0 )
	errorMessage = (stackLine and stackLine:match("^.-:.-: ") or "") .. errorMessage
	return errorhandler(errorMessage) or errorMessage
end
local softerror = LibShared.softerror



-----------------------------
--- LibShared. softassert(condition, message):  Report error, then continue execution, *unlike* assert().
-- Check for unexpected values or anomalies without crashing. Reports anomaly, then continues your function, unlike assert().
-- @param condition - result of a check that is expected to return a truthy value.
-- @param message - error message passed to  errorhandler()  if condition fails.
-- @return condition  [, garbage] (condition or message returned by builtin errorhandler _ERRORMESSAGE, or nothing returned by BugGrabber's errorhandler )
--
-- Copy-paste these 4 lines to your file to include without depending on LibShared being loaded.
--- LibShared. softassert(condition, message):  Report error, then continue execution, *unlike* assert().
local LibShared = G.LibShared or {}  ;  G.LibShared = LibShared
LibShared.softassert = LibShared.softassert  or  function(ok, message)  return ok, ok or LibShared.softerror(message, 1)  end
-- LibShared.softassert = LibShared.softassert  or  function(ok, message, stackDepth)  return ok, ok or LibShared.softerror(message, (stackDepth or 0)+1)  end
local softassert = LibShared.softassert

--[[ Simpler versions to include in your file:  use the 2nd if you import errorhandler() too. Makes more readable stacktrace.
LibShared.softassert = LibShared.softassert  or  function(ok, message)  return ok, ok or _G.geterrorhandler()(message)  end
LibShared.softassert = LibShared.softassert  or  function(ok, message)  return ok, ok or LibShared.errorhandler(message)  end
--]]

-- You can use the return value to make compact statements:
--  local name = softassert(namestorage[dataobj], "Missing name of dataobj.") or "?"
--


-----------------------------
--- LibShared. softassertf( condition, messageFormat, formatParameter...):  Report error, then continue execution, *unlike* assert(). Formatted error message.
-- @param condition - result of a check that is expected to return a truthy value.
-- @param messageFormat - error message passed to  string.format(), then  errorhandler()  if condition fails.
-- @return condition, (message if condition fails)
--
LibShared.softassertf = LibShared.softassertf  or  function(ok, messageFormat, ...)
	if ok then  return ok,nil  end  ;  local message = format(messageFormat, ...)  ;  LibShared.softerror(message)  ;  return ok,message
end


-----------------------------
--- LibShared. asserttype(value, typename, [messagePrefix]):  Raises error (stops execution) if value's type is not the expected `typename`.
-- @param value - to check for type.
-- @param typename (string) - name of expected type.
-- @param messagePrefix (string/nil) - optional error message prefixed to:  "<typename> expected, got <type>"
--
-- Usage:  asserttype(inputFields, 'table', "Usage: LDB:NewDataObject(name, dataobject):  `dataobject` - ")
--
LibShared.asserttype = LibShared.asserttype  or  function(value, typename, messagePrefix, callDepth)
	if type(value)~=typename then  error( (messagePrefix or "")..typename.." expected, got "..type(value), (callDepth or 0)+2 )  end
end


-----------------------------
--- LibShared. asserttypeOrNil(value, typename, [messagePrefix]):  Raises error (stops execution) if value's type is not the expected `typename` and value is not nil.
-- @param value - to check for type.
-- @param typename (string) - name of expected type.
-- @param messagePrefix (string/nil) - optional error message prefixed to:  "<typename> expected, got <type>"
--
LibShared.asserttypeOrNil = LibShared.asserttypeOrNil  or  function(value, typename, messagePrefix, callDepth)
	if nil~=value and type(value)~=typename then  error( (messagePrefix or "")..typename.." or nil expected, got "..type(value), (callDepth or 0)+2 )  end
end


-----------------------------
--- LibShared. asserttypeOrFalse(value, typename, [messagePrefix]):  Raises error (stops execution) if value's type is not the expected `typename` and value is not nil or false.
-- @param value - to check for type.
-- @param typename (string) - name of expected type.
-- @param messagePrefix (string/nil) - optional error message prefixed to:  "<typename> expected, got <type>"
--
LibShared.asserttypeOrFalse = LibShared.asserttypeOrFalse  or  function(value, typename, messagePrefix, callDepth)
	if value and type(value)~=typename then  error( (messagePrefix or "")..typename.." expected, got "..type(value), (callDepth or 0)+2 )  end
end


-----------------------------
--- LibShared. assertf(condition, messageFormat, formatParameter...):  Raises error (stops execution) if condition fails. Formatted error message.
-- @param condition - result of a check that is expected to return a truthy value.
-- @param messageFormat - error message passed to  string.format(), then  error()  if condition fails.
-- Stops execution if condition fails, like  assert().
--
LibShared.assertf = LibShared.assertf  or  function(ok, messageFormat, ...)  if not ok then  error( format(messageFormat, ...), 2 )  end  end
LibShared.assertnf = LibShared.assertnf  or  function(callDepth, ok, messageFormat, ...)
	callDepth = tonumber(callDepth)
  if not ok or not callDepth then  error( format(messageFormat, ...), (callDepth or 0)+2 )  end
end






-- Alternatives:
--[[
LibShared.softassert = LibShared.softassert or  function(ok, message)
	-- return  ok,  ok  or  (LibShared.errorhandler(message) or message)  or  nil
	-- if ok then  return ok,nil  else  LibShared.errorhandler(message) ; return ok,message  end
	-- if not ok then  LibShared.errorhandler(message) ; return ok,message  else  return ok,nil  end
	-- if not ok then  LibShared.errorhandler(message) ; return ok,message  else  return ok,nil  end
	-- if not ok then  LibShared.errorhandler(message)  end ; return ok, ok and message or nil  end
	-- if not ok then  LibShared.errorhandler(message)  end ; return ok  end
	-- return ok, not ok and LibShared.errorhandler(message)  end
	-- return ok, ( ok or LibShared.errorhandler(message) ) and nil  end
	-- return ok, ok or LibShared.errorhandler(message)  end
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


