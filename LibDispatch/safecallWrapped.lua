local G, LIB_NAME, LIB_REVISION  =  _G, 'LibDispatch', 1
assert(LibStub and LibStub.NewLibraryPart, 'Include "LibStub.NewLibraryPart.lua" before LibDispatch.')
local LibDispatch = LibStub:NewLibraryPart(LIB_NAME, LIB_REVISION, 'safecallWrapped')
 
-- GLOBALS:
-- Used from _G:  [geterrorhandler]
-- Used from LibShared:  errorhandler, softassert
-- Used from LibDispatch:  CallWrapper
-- Exported to LibShared:  safecall, safecallWrapped
local LibShared = G.LibShared or {}  ;  G.LibShared = LibShared


------------------------------
--- LibShared. safecallWrapped(unsafeFunc, arg1, arg2, ...)
--
-- Similar to pcall(unsafeFunc, arg1, arg2, ...)
-- with proper errorhandler while executing unsafeFunc.
--
if LibDispatch then

	local errorhandler = G.assert(LibShared.errorhandler, 'Include "LibShared.softassert.lua" before.')
	local CallWrapper = G.assert(LibDispatch.CallWrapper, 'Include "CallWrapper*.lua" before.')

	function LibShared.safecallWrapped(unsafeFunc, ...)
		-- unsafeFunc is optional. If provided, it must be a function or a callable table.
		if not unsafeFunc then  return  end
		if type(unsafeFunc)~='function' and type(unsafeFunc)~='table' then
			LibShared.softassert(false, "Usage: safecall(unsafeFunc):  function or callable table expected, got "..type(unsafeFunc))
			return
		end

		-- Pass a delegating errorhandler to avoid G.geterrorhandler() function call before any error actually happens.
		-- local errorhandler = LibShared.errorhandler    -- Upvalued above.
		-- Or pass the registered errorhandler directly to avoid inserting an extra callstack frame.
		-- local errorhandler = G.geterrorhandler()

		-- Save arguments (parameter values).
		local wrapper = CallWrapper(...)
		local closure = wrapper(unsafeFunc)

		-- Avoid tailcall with select(1,...).
		return select( 1, xpcall(closure, errorhandler) )
	end


end -- LibShared.safecallWrapped



LibShared.safecall = LibShared.safecall or LibShared.safecallWrapped


