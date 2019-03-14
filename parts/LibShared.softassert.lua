local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  geterrorhandler (might be hooked/modified), debugstack, string.match
-- Used from LibShared:
-- Exported to LibShared:  softerror, softassert, softassertf
-- Updates in LibShared:  errorhandler

-- Upvalued Lua globals:
local format = G.string.format


--[[ Copy-paste samples:
softassert(LibStub('AceEvent-3.0'), 'Include "AceEvent-3.0.lua" before.')
softerror( not LibStub('AceEvent-3.0')  and  'Include "AceEvent-3.0.lua" before.' )
local lib = "AceEvent-3.0" ; softassertf(LibStub(lib), 'Include "%s" before.', lib)
local lib = "AceEvent-3.0" ; softassertf(LibStub(lib), 'Include %q before.', lib)
--]]


-----------------------------
--- LibShared.softerror(errorMessage, stackDepth):  Report error, with the line causing it, then continue execution, *unlike* error().
-- @param  errorMessage  nil/false  if there is no error, and softerror() should return without doing anything.
-- Use it when `errorMessage` is a calculated string that you don't want to create every time, only if the error condition is true, like so:
--  LibShared.softerror( somethingwrong and "Error:  "..tostring(somethingwrong).."  happened at "..date("%H:%M:%S") )
--  -- tostring() and date() will be executed only if `somethingwrong` evaluates to trueish.
-- @param `stackDepth` (number)  how many calls higher up in the callstack is the causing line.
--   -1 smaller than the 2nd parameter to error(). 0 == where softerror() is called.
--
-- Calls the registered errorhandler without tailcall to generate readable stacktrace.
-- Allows hooking G.geterrorhandler().
-- Calls through LibShared.errorhandler(), thus the errorhandler() function name is printed in stacktrace, not just a line number.
-- Avoids tailcall and returns the errorMessage like the builtin errorhandler with `or errorMessage`.
--
function LibShared.softerror(errorMessage, stackDepth)
	if not errorMessage then  return errorMessage  end
  local stackLine = G.debugstack( (stackDepth or 0)+2, 1, 0 )
	errorMessage = (stackLine and stackLine:match("^.-:.-: ") or "") .. errorMessage
	LibShared.errorhandler = G.geterrorhandler()
	return LibShared.errorhandler(errorMessage) or errorMessage
end

--[[ Simpler versions to include in your file:  will be overwritten with the advanced version if LibShared is loaded.
--- LibShared.softerror(message):  Report error, then continue execution, *unlike* error().
LibShared.softerror = LibShared.softerror or _G.geterrorhandler()
LibShared.softerror = LibShared.softerror or LibShared.errorhandler
--]]


-----------------------------
--- LibShared.softassert(condition, message):  Report error, then continue execution, *unlike* assert().
-- Check for unexpected values or anomalies without crashing. Reports anomaly, then continues your function, unlike assert().
-- @param condition - result of a check that is expected to return a trueish value.
-- @param message - error message passed to  errorhandler()  if condition fails.
-- @return condition  [, garbage] (condition or message returned by builtin errorhandler _ERRORMESSAGE, or nothing returned by BugGrabber's errorhandler )
--
-- Copy-paste these 4 lines to your file to include without depending on LibShared being loaded.
--- LibShared. softassert(condition, message):  Report error, then continue execution, *unlike* assert().
local LibShared = G.LibShared or {}  ;  G.LibShared = LibShared
function LibShared.softassert(ok, message)
	return ok, ok or LibShared.softerror(message or "", 1)
end
-- function LibShared.softassert(ok, message, stackDepth)  return ok, ok or LibShared.softerror(message, (stackDepth or 0)+1)  end


--[[ Simpler versions to include in your file as a fallback:  use the 2nd if you include LibShared.errorhandler.lua too. Makes more readable stacktrace.
LibShared.softassert = LibShared.softassert  or  function(ok, message)  return ok, ok or _G.geterrorhandler()(message)  end
LibShared.softassert = LibShared.softassert  or  function(ok, message)  return ok, ok or LibShared.errorhandler(message)  end
--]]

-- You can use the return value to make compact statements:
--  local name = softassert(namestorage[dataobj], "Missing name of dataobj.") or "?"
--


-----------------------------
--- LibShared.softassertf( condition, messageFormat, formatParameter...):  Report error, then continue execution, *unlike* assert(). Formatted error message.
-- @param condition - result of a check that is expected to return a truthy value.
-- @param messageFormat - error message passed to  string.format(), then  errorhandler()  if condition fails.
-- @return condition, (message if condition fails)
--
function LibShared.softassertf(ok, messageFormat, ...)
	if ok then  return ok,nil  end  ;  local message = format(messageFormat, ...)  ;  LibShared.softerror(message, 1)  ;  return ok,message
end


-----------------------------
--- softerrorf(...) = softassertf(false, ...)




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


