local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
-- local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  geterrorhandler
-- Used from LibShared:  [softassert]
-- Exported to LibShared:  safecall, safecallDynamic, errorhandler, softassert


--------------------------------------------------
--- LibShared.  safecallDynamic(unsafeFunc, arg1, arg2, ...)
--
-- Alternative implementation without loadstring() (dynamic code).
-- Handles any number of arguments by packing them in an array and unpacking in the xpcallClosure.
-- Simpler and probably slower with an extra array creation on each call.
-- Easier to recognize in a callstack.
--
if not LibShared.safecallDynamic then

	-- Upvalued Lua globals
	local xpcall,type,select,unpack = xpcall,type,select,unpack
	-- Used from LibShared:
	local errorhandler = G.assert(LibShared.errorhandler, 'Include "LibShared.softassert.lua" before.')
	

	function LibShared.safecallDynamic(unsafeFunc, ...)
		-- we check to see if the unsafeFunc passed is actually a function here and don't error when it isn't
		-- this safecall is used for optional functions like OnInitialize OnEnable etc. When they are not
		-- present execution should continue without hinderance
		if  not unsafeFunc  then  return  end
		if  type(unsafeFunc)~='function'  then
			LibShared.softassert(false, "Usage: safecall(unsafeFunc):  function expected, got "..type(unsafeFunc))
			return
		end

		local argsN, xpcallClosure = select('#',...)
		if  0 < argsN  then
			-- Pack the parameters in a closure to pass to the actual function.
			local args = {...}
			-- Unpack the parameters in the closure.
			xpcallClosure = function()  return unsafeFunc( unpack(args,1,argsN) )  end
		end

		-- Do the call through the closure.
		-- Without parameters call the function directly.
		return xpcall(xpcallClosure or unsafeFunc, errorhandler)
		-- return xpcall(xpcallClosure or unsafeFunc, G.geterrorhandler())
	end

end -- LibShared.safecallDynamic



LibShared.safecall = LibShared.safecall or LibShared.safecallDynamic


