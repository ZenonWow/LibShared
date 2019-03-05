local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
-- local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  geterrorhandler, table.concat, assert, loadstring  (ca. 5 times)
-- Used from LibShared:  [softassert]
-- Exported to LibShared:  safecall, safecallDispatch, errorhandler, softassert


-------------------------------------------
--- LibShared.  safecallDispatch(unsafeFunc, arg1, arg2, ...)
--
-- Similar to pcall(unsafeFunc, arg1, arg2, ...)
-- with proper errorhandler while executing unsafeFunc.
--
if not LibShared.safecallDispatch then

	-- Upvalued Lua globals
	local xpcall,type,select = xpcall,type,select

	-- Allow hooking _G.geterrorhandler(): don't cache/upvalue it or the errorhandler returned.
	-- Call through errorhandler() local, thus the errorhandler() function name is printed in stacktrace, not just a line number.
	-- Also avoid tailcall with select(1,...). A tailcall would show LibShared.errorhandler() function as "?" in stacktrace, making it harder to identify.
	LibShared.errorhandler = LibShared.errorhandler or  function(errorMessage)  local errorhandler = _G.geterrorhandler() ; return select( 1, errorhandler(errorMessage) )  end
	local errorhandler = LibShared.errorhandler


	local SafecallDispatchers = {}
	function SafecallDispatchers:CreateDispatcher(argCount)
		local sourcecode = [===[
			local xpcall, errorhandler = ...
			local unsafeFuncUpvalue, ARGS
			local function xpcallClosure()  return unsafeFuncUpvalue(ARGS)  end

			local function dispatcher(unsafeFunc, ...)
				 unsafeFuncUpvalue, ARGS = unsafeFunc, ...
				 return xpcall(xpcallClosure, errorhandler)
				 -- return xpcall(xpcallClosure, geterrorhandler())
			end

			return dispatcher
		]===]

		local ARGS = {}
		for i = 1, argCount do ARGS[i] = "a"..i end
		sourcecode = sourcecode:gsub("ARGS", _G.table.concat(ARGS, ","))
		local creator = _G.assert(_G.loadstring(sourcecode, "SafecallDispatchers[argCount="..argCount.."]"))
		local dispatcher = creator(xpcall, errorhandler)
		self[argCount] = dispatcher
		return dispatcher
	end

	setmetatable(SafecallDispatchers, { __index = SafecallDispatchers.CreateDispatcher })

	SafecallDispatchers[0] = function (unsafeFunc)
		-- Pass a delegating errorhandler to avoid _G.geterrorhandler() function call before any error actually happens.
		return xpcall(unsafeFunc, errorhandler)
		-- Or pass the registered errorhandler directly to avoid inserting an extra callstack frame.
		-- The errorhandler is expected to be the same at both times: callbacks usually don't change it.
		--return xpcall(unsafeFunc, _G.geterrorhandler())
	end


	function LibShared.safecallDispatch(unsafeFunc, ...)
		-- we check to see if unsafeFunc is actually a function here and don't error when it isn't
		-- this safecall is used for optional functions like OnInitialize OnEnable etc. When they are not
		-- present execution should continue without hinderance
		if  not unsafeFunc  then  return  end
		if  type(unsafeFunc)~='function'  then
			LibShared.softassert(false, "Usage: safecall(unsafeFunc):  function expected, got "..type(unsafeFunc))
			return
		end

		local dispatcher = SafecallDispatchers[select('#',...)]
		-- Can't avoid tailcall without inefficiently packing and unpacking the multiple return values.
		return dispatcher(unsafeFunc, ...)
	end


	--- LibShared. softassert(condition, message):  Report error, then continue execution, _unlike_ assert().
	LibShared.softassert = LibShared.softassert  or  function(ok, message)  return ok, ok or _G.geterrorhandler()(message)  end

end -- LibShared.safecallDispatch



LibShared.safecall = LibShared.safecall or LibShared.safecallDispatch


