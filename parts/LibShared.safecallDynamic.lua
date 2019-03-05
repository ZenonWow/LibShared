local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
-- local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

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

	-- Allow hooking _G.geterrorhandler(): don't cache/upvalue it or the errorhandler returned.
	-- Call through errorhandler() local, thus the errorhandler() function name is printed in stacktrace, not just a line number.
	-- Also avoid tailcall with select(1,...). A tailcall would show LibShared.errorhandler() function as "?" in stacktrace, making it harder to identify.
	LibShared.errorhandler = LibShared.errorhandler or  function(errorMessage)  local errorhandler = _G.geterrorhandler() ; return select( 1, errorhandler(errorMessage) )  end
	local errorhandler = LibShared.errorhandler
	

	function LibShared.safecallDynamic(unsafeFunc, ...)
		-- we check to see if the unsafeFunc passed is actually a function here and don't error when it isn't
		-- this safecall is used for optional functions like OnInitialize OnEnable etc. When they are not
		-- present execution should continue without hinderance
		if  not unsafeFunc  then  return  end
		if  type(unsafeFunc)~='function'  then
			LibShared.softassert(false, "Usage: safecall(unsafeFunc):  function expected, got "..type(unsafeFunc))
			return
		end

		local argsCount, xpcallClosure = select('#',...)
		if  0 < argsCount  then
			-- Pack the parameters in a closure to pass to the actual function.
			local args = {...}
			-- Unpack the parameters in the closure.
			xpcallClosure = function()  return unsafeFunc( unpack(args,1,argsCount) )  end
		end

		-- Do the call through the closure.
		-- Without parameters call the function directly.
		return xpcall(xpcallClosure or unsafeFunc, errorhandler)
		-- return xpcall(xpcallClosure or unsafeFunc, _G.geterrorhandler())
	end


	--- LibShared. softassert(condition, message):  Report error, then continue execution, _unlike_ assert().
	LibShared.softassert = LibShared.softassert  or  function(ok, message)  return ok, ok or _G.geterrorhandler()(message)  end

end -- LibShared.safecallDynamic



LibShared.safecall = LibShared.safecall or LibShared.safecallDynamic


