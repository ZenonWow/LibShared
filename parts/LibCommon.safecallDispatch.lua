local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
-- local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:  GetBuildInfo, geterrorhandler, table.concat, assert, loadstring  (ca. 5 times)
-- Used from LibCommon:  [softassert]
-- Exported to LibCommon:  safecall, safecallDispatch, errorhandler, softassert


-------------------------------------------
--- LibCommon.  safecallDispatch(unsafeFunc, arg1, arg2, ...)
--
-- Similar to pcall(unsafeFunc, arg1, arg2, ...)
-- with proper errorhandler while executing unsafeFunc.
--
if not LibCommon.safecallDispatch then

	-- Upvalued Lua globals
	local xpcall,type,select = xpcall,type,select

	-- Allow hooking _G.geterrorhandler(): don't cache/upvalue it or the errorhandler returned.
	-- Avoid tailcall:  errorhandler() function would show up as "?" in stacktrace, making it harder to understand.
	LibCommon.errorhandler = LibCommon.errorhandler or  function(errorMessage)  return true and _G.geterrorhandler()(errorMessage)  end
	local errorhandler = LibCommon.errorhandler


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


	function LibCommon.safecallDispatch(unsafeFunc, ...)
		-- we check to see if unsafeFunc is actually a function here and don't error when it isn't
		-- this safecall is used for optional functions like OnInitialize OnEnable etc. When they are not
		-- present execution should continue without hinderance
		if  not unsafeFunc  then  return  end
		if  type(unsafeFunc)~='function'  then
			LibCommon.softassert(false, "Usage: safecall(unsafeFunc):  function expected, got "..type(unsafeFunc))
			return
		end

		local dispatcher = SafecallDispatchers[select('#',...)]
		-- Can't avoid tailcall without inefficiently packing and unpacking the multiple return values.
		return dispatcher(unsafeFunc, ...)
	end


	-- softassert(condition, message):  Report error without halting.
	LibCommon.softassert = LibCommon.softassert or  function(ok, message)  return ok, ok or _G.geterrorhandler()(message)  end

end -- LibCommon.safecallDispatch



LibCommon.safecall = LibCommon.safecall or LibCommon.safecallDispatch


