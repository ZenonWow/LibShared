local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  geterrorhandler, xpcall
-- Used from LibShared:  errorhandler, softassert
-- Exported to LibShared:  safecall, safecallDynamic


--------------------------------------------------
--- LibShared. safecallDynamic(unsafeFunc, arg1, arg2, ...)
--
-- Alternative implementation without loadstring() (dynamic code).
-- Handles any number of arguments by packing them in an array and unpacking in the xpcallClosure.
-- Simpler and probably slower with an extra array creation on each call.
-- Easier to recognize in a callstack.
--
-- This is a trimmed version of LibDispatch.CallWrapperDynamic(), with methodClosure() removed and xpcall() added.
-- Saving arguments (wrapper creation) and saving function (closure creation) is merged.
--
if not LibShared.safecallDynamic then

	-- Upvalued Lua globals
	local type,select,unpack = type,select,unpack
	-- Used from LibShared:
	G.assert(LibShared.errorhandler, 'Include "LibShared.errorhandler.lua" before.')
	G.assert(LibShared.softerror, 'Include "LibShared.softassert.lua" before.')
	

	function LibShared.safecallDynamic(unsafeFunc, ...)
		-- unsafeFunc is optional. If provided, it must be a function or a callable table.
		if not unsafeFunc then  return  end
		if type(unsafeFunc)~='function' and type(unsafeFunc)~='table' then
			LibShared.softerror("Usage: safecall(unsafeFunc):  function or callable table expected, got "..type(unsafeFunc))
			return
		end

		local argNum, closure = select('#',...)
		if  0 == argNum  then
		-- Without parameters call the function directly.
			closure = unsafeFunc
		elseif  1 == argNum  then
			local arg1 = ...
			closure = function()  return select( 1, unsafeFunc(arg1) )  end
		else
			-- Pack the parameters in a closure to pass to the actual function.
			local args = {...}
			-- Unpack the parameters in the closure.
			closure = function()  return select( 1, unsafeFunc(unpack(args,1,argNum)) )  end
		end

		-- Do the call through xpcall and the closure. Avoid tailcall with select(1,...). Call G.xpcall() instead of xpcall(), so it shows its name in the callstack.
		return select( 1, G.xpcall(closure, LibShared.errorhandler) )
	end

end -- LibShared.safecallDynamic


