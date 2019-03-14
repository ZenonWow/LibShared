local G, LIB_NAME, LIB_REVISION  =  _G, 'LibDispatch', 1
-- assert(LibStub and LibStub.NewLibraryPart, 'Include "LibStub.NewLibraryPart.lua" before LibDispatch.')
-- local LibDispatch = LibStub:NewLibraryPart(LIB_NAME, LIB_REVISION, 'safecallWrapped')

-- This is the last file in the library, marking the whole library upgraded to this LIB_REVISION.
assert(LibStub, 'Include "LibStub.lua" before LibDispatch.')
local LibDispatch = LibStub:NewLibrary(LIB_NAME, LIB_REVISION)
if not LibDispatch then  return  end
 
-- GLOBALS:
-- Used from _G:  [geterrorhandler]
-- Used from LibShared:  softerror
-- Used from LibDispatch:  CallWrapper
local CallWrapper = G.assert(LibDispatch.CallWrapper, 'Include "CallWrapper*.lua" before.')
-- Exported to LibShared:  safecall, safecallWrapped, errorhandler, [softerror]
local LibShared = G.LibShared or {}  ;  G.LibShared = LibShared

--- LibShared.errorhandler(errorMessage):  == _G.geterrorhandler()( errorMessage )
LibShared.errorhandler = G.geterrorhandler()


------------------------------
--- LibShared. safecallWrapped(unsafeFunc, arg1, arg2, ...)
--
-- Similar to pcall(unsafeFunc, arg1, arg2, ...)
-- with proper errorhandler while executing unsafeFunc.
--
function LibShared.safecallWrapped(unsafeFunc, ...)
	-- unsafeFunc is optional. If provided, it must be a function or a callable table.
	if not unsafeFunc then  return  end
	if type(unsafeFunc)~='function' and type(unsafeFunc)~='table' then
		LibShared.softerror = LibShared.softerror or LibShared.errorhandler
		LibShared.softerror("Usage: safecall(unsafeFunc):  function or callable table expected, got "..type(unsafeFunc))
		return
	end

	-- Save arguments (parameter values).
	local wrapper = CallWrapper(...)
	local closure = wrapper(unsafeFunc)

	-- Do the call through xpcall and the closure. Avoid tailcall with select(1,...). Call G.xpcall() instead of xpcall(), so it shows its name in the callstack.
	return select( 1, G.xpcall(closure, LibShared.errorhandler) )
end


