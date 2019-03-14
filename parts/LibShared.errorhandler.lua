local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  geterrorhandler (might be hooked/modified)
-- Hooked in _G:  seterrorhandler
-- Used from LibShared:
-- Updates in LibShared:  errorhandler
-- Exported to LibShared:  CallErrorHandler
-- Upvalued Lua globals:


--[[ Copy-paste usage:
xpcall(unsafeFunction, LibShared.CallErrorHandler)
--]]


-----------------------------
--- LibShared. CallErrorHandler(errorMessage):  Calls the registered errorhandler, without tailcall to generate readable stacktrace.
-- Allows hooking G.geterrorhandler().
-- Forces lua to show the `errorhandler()` function name in the callstack by calling through a field, not a local variable...  go figure.
-- Avoids tailcall with `or errorMessage`.
-- The name and functionality is similar to the builtin  _G.CallErrorHandler(...)  (@see SharedXML/Util.lua), with the above mentioned usability / quality-of-life features added.
-- @return  the errorMessage  like the builtin errorhandler DisplayMessageInternal() does (@see SharedXML/SharedBasicControls.lua), and _ERRORMESSAGE() did until WoD.
--
LibShared.CallErrorHandler = LibShared.CallErrorHandler or  function(errorMessage, ...)  LibShared.errorhandler = G.geterrorhandler() ; return LibShared.errorhandler(errorMessage, ...) or errorMessage  end


-----------------------------
--- LibShared.errorhandler(errorMessage):  == _G.geterrorhandler()( errorMessage )
--
LibShared.errorhandler = G.geterrorhandler()
-- Note: BugGrabber loads before this, so it won't replace seterrorhandler() later.
G.hooksecurefunc('seterrorhandler', function(setHandler)
	LibShared.errorhandler = G.geterrorhandler()
end)




-----------------------------
-- Note about  errorhandler(message):
-- The builtin version until 7.2.5 was _ERRORMESSAGE() which returns `message` (@see FrameXML/BasicControls.xml#_ERRORMESSAGE() ).
-- The builtin version since 7.2.5 is HandleLuaError() which wraps DisplayMessageInternal() and eliminates the return message (@see SharedXML/SharedBasicControls.lua).
-- The following addon overrides also return nothing:
-- BugGrabber.lua#grabError()
-- Swatter.lua#OnErrorHandler
-- tekErr.lua
-- TradeSkillMaster/Core/ErrorHandler.lua#TSMErrorHandler()
-- Auctionator/AtrErrorInspector.lua#Atr_Error_Handler()
-- LUI/scripts/bugcatcher.lua#script.new()


