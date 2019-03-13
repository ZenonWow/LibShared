local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from global in code snippet:  select, xpcall
-- Used from _G:  [geterrorhandler], table.concat, tostring, assert, loadstring  (ca. 5 times)
-- Used from LibShared:  errorhandler, softassert
-- Exported to LibShared:  safecall, safecallForArgNum2


-------------------------------------------
--- LibShared. safecallForArgNum2(unsafeFunc, arg1, arg2, ...)
--
-- Similar to pcall(unsafeFunc, arg1, arg2, ...)
-- with proper errorhandler while executing unsafeFunc.
--
if not LibShared.safecallForArgNum2 then

	-- Upvalued Lua globals:
	local xpcall,type,select = xpcall,type,select
	-- Used from LibShared:
	local errorhandler = G.assert(LibShared.errorhandler, 'Include "LibShared.softassert.lua" before.')


	local SafecallForArgNum = {}

	local createSafecallForArgNum = [===[
		callback, errorhandler, ARGS = ...
		local function functionClosure()  return select( 1, callback(ARGS) )  end
		return xpcall(functionClosure, errorhandler)
		-- return xpcall(functionClosure, geterrorhandler())
	]===]

	function SafecallForArgNum:CreateForArgNum2(argNum)
		local ARGS = {}
		for i = 1,argNum do  ARGS[i] = "a"..i  end
		local sourcecode = createSafecallForArgNum:gsub("ARGS", G.table.concat(ARGS, ","))
		local xpcallForArgNum = G.assert( G.loadstring(sourcecode, "SafecallForArgNum[argNum="..argNum.."]") )
		self[argNum] = xpcallForArgNum
		return xpcallForArgNum
	end


	setmetatable(SafecallForArgNum, { __index = SafecallForArgNum.CreateForArgNum })

	SafecallForArgNum[0] = function(unsafeFunc)
		-- Pass a delegating errorhandler to avoid G.geterrorhandler() function call before any error actually happens.
		return xpcall(unsafeFunc, errorhandler)
		-- Or pass the registered errorhandler directly to avoid inserting an extra callstack frame.
		-- return xpcall(unsafeFunc, G.geterrorhandler())
	end


	function LibShared.safecallForArgNum2(unsafeFunc, ...)
		-- unsafeFunc is optional. If provided, it must be a function or a callable table.
		if not unsafeFunc then  return  end
		if type(unsafeFunc)~='function' and type(unsafeFunc)~='table' then
			LibShared.softassert(false, "Usage: safecall(unsafeFunc):  function or callable table expected, got "..type(unsafeFunc))
			return
		end

		-- Called xpcall.. cause the 2nd parameter is the errorhandler, as in xpcall(), but _not_ in safecall().
		local xpcallForArgNum = SafecallForArgNum[ select('#',...) ]
		-- Avoid tailcall with select(1,...).
		return select( 1, xpcallForArgNum(unsafeFunc, errorhandler, ...) )
	end


	LibShared.safecall = LibShared.safecall or LibShared.safecallForArgNum2

end -- LibShared.safecallForArgNum2


