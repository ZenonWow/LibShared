-- Export  LibCommon.safecallDynamic


--------------------------------------------------
-- safecallDynamic(unsafeFunc, arg1, arg2, ...)
--
-- Alternative implementation without loadstring() (dynamic code).
-- Handles any number of arguments by packing them in an array and unpacking in the xpcallClosure.
-- Simpler and probably slower with an extra array creation on each call.
-- Easier to recognize in a callstack.


if  select(4, GetBuildInfo()) >= 80000  then

	----------------------------------------
	--- Battle For Azeroth Addon Changes
	-- https://us.battle.net/forums/en/wow/topic/20762318007
	-- • xpcall now accepts arguments like pcall does
	--
	LibCommon.safecall = LibCommon.safecall or  function(unsafeFunc, ...)  return xpcall(unsafeFunc, errorhandler, ...)  end

elseif not LibCommon.safecallDynamic then

	-- Allow hooking _G.geterrorhandler(): don't cache/upvalue it or the errorhandler returned.
	-- Avoiding tailcall: errorhandler() function would show up as "?" in stacktrace, making it harder to understand.
	LibCommon.errorhandler = LibCommon.errorhandler or  function(errorMessage)  return true and _G.geterrorhandler()(errorMessage)  end
	local errorhandler = LibCommon.errorhandler
	
	function LibCommon.safecallDynamic(unsafeFunc, ...)
		-- we check to see if the unsafeFunc passed is actually a function here and don't error when it isn't
		-- this safecall is used for optional functions like OnInitialize OnEnable etc. When they are not
		-- present execution should continue without hinderance
		if  not unsafeFunc  then  return  end
		if  type(unsafeFunc)~='function'  then
			_G.geterrorhandler()("Usage: safecall(unsafeFunc):  function expected, got "..type(unsafeFunc))
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

end -- LibCommon.safecallDynamic




LibCommon.safecall = LibCommon.safecall or LibCommon.safecallDynamic



