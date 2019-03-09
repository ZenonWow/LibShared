local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from global in code snippet:  select, xpcall
-- Used from _G:  [geterrorhandler], table.concat, tostring, assert, loadstring  (ca. 5 times)
-- Used from LibShared:  errorhandler, softassert
-- Exported to LibShared:  safecall, safecallForArgNum


-------------------------------------------
--- LibShared. safecallForArgNum(unsafeFunc, arg1, arg2, ...)
--
-- Similar to pcall(unsafeFunc, arg1, arg2, ...)
-- with proper errorhandler while executing unsafeFunc.
--
-- This is a trimmed version of LibDispatch.CallWrapperForArgNum(), with methodClosure() removed and xpcall() added.
-- Saving arguments (wrapper creation) and saving function (closure creation) is merged.
--
if not LibShared.safecallForArgNum then

	-- Upvalued Lua globals:
	local xpcall,type,select = xpcall,type,select
	-- Used from LibShared:
	local errorhandler = G.assert(LibShared.errorhandler, 'Include "LibShared.softassert.lua" before.')


	local ClosureCreators = {}

	-- This is called `wrapperCreatorForArgNum` in the original. Here the wrapper step is merged with the closure creation.
	local closureCreatorForArgNum = [===[
		callback, ARGS = ...
		return function()  return select( 1, callback(ARGS) )  end
	]===]

	function ClosureCreators:CompileCreator(argNum)
		local ARGS = {}
		for i = 1,argNum do  ARGS[i] = "a"..i  end
		local sourcecode = closureCreatorForArgNum:gsub("ARGS", G.table.concat(ARGS, ","))
		local creator = G.assert( G.loadstring(sourcecode, "ClosureCreators[argNum="..argNum.."]") )
		self[argNum] = creator
		return creator
	end


	ClosureCreators[0] = function(unsafeFunc)  return unsafeFunc  end
	setmetatable(ClosureCreators, { __index = ClosureCreators.CompileCreator })


	function LibShared.safecallForArgNum(unsafeFunc, ...)
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

		local closureCreator = ClosureCreators[ select('#',...) ]
		local closure = closureCreator(unsafeFunc, ...)
		-- Avoid tailcall with select(1,...).
		return select( 1, xpcall(closure, errorhandler) )
	end

end -- LibShared.safecallForArgNum



LibShared.safecall = LibShared.safecall or LibShared.safecallForArgNum


