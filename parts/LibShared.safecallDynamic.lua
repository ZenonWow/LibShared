local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  geterrorhandler
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
	local xpcall,type,select,unpack = xpcall,type,select,unpack
	-- Used from LibShared:
	local errorhandler = G.assert(LibShared.errorhandler, 'Include "LibShared.softassert.lua" before.')
	

	function LibShared.safecallDynamic(unsafeFunc, ...)
		-- unsafeFunc is optional. If provided, it must be a function or a callable table.
		if not unsafeFunc then  return  end
		if type(unsafeFunc)~='function' and type(unsafeFunc)~='table' then
			LibShared.softassert(false, "Usage: safecall(unsafeFunc):  function or callable table expected, got "..type(unsafeFunc))
			return
		end

		local argNum, functionClosure = select('#',...)
		if  0 == argNum  then
		-- Without parameters call the function directly.
			functionClosure = unsafeFunc
		elseif  1 == argNum  then
			local arg1 = ...
			functionClosure = function()  unsafeFunc(arg1)  end
		else
			-- Pack the parameters in a closure to pass to the actual function.
			local args = {...}
			-- Unpack the parameters in the closure.
			functionClosure = function()  return unsafeFunc( unpack(args,1,argNum) )  end
		end

		-- Do the call through the closure.
		return xpcall(functionClosure, errorhandler)
		-- return xpcall(functionClosure, G.geterrorhandler())
	end

end -- LibShared.safecallDynamic



LibShared.safecall = LibShared.safecall or LibShared.safecallDynamic


