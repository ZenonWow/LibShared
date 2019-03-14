local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from global in code snippet:  select, xpcall
-- Used from _G:  [geterrorhandler], table.concat, tostring, assert, loadstring  (ca. 5 times)
-- Used from LibShared:  errorhandler, softassert
-- Exported to LibShared:  safecall, safecallForArgNum1


-------------------------------------------
--- LibShared. safecallForArgNum1(unsafeFunc, arg1, arg2, ...)
--
-- Similar to pcall(unsafeFunc, arg1, arg2, ...)
-- with proper errorhandler while executing unsafeFunc.
--
if not LibShared.safecallForArgNum1 then

	-- Upvalued Lua globals:
	local xpcall,type,select = xpcall,type,select
	-- Used from LibShared:
	G.assert(LibShared.errorhandler, 'Include "LibShared.errorhandler.lua" before.')
	G.assert(LibShared.softerror, 'Include "LibShared.softassert.lua" before.')


	local XPcallForArgNum = {}

	local createXPcallForArgNum = [===[
		local select, xpcall = select, xpcall, ...
		local callback, ARGS
		local function functionClosure()  return select( 1, callback(ARGS) )  end

		return function(unsafeFunc, errorhandler, ...)
			callback, ARGS = unsafeFunc, ...
			return xpcall(functionClosure, errorhandler)
		end
	]===]

	function XPcallForArgNum:CreateForArgNum(argNum)
		local ARGS = {}
		for i = 1,argNum do  ARGS[i] = "a"..i  end
		local sourcecode = createXPcallForArgNum:gsub("ARGS", G.table.concat(ARGS, ","))
		local creator = G.assert( G.loadstring(sourcecode, "XPcallForArgNum[argNum="..argNum.."]") )
		local safecallForArgNum = creator(errorhandler)
		self[argNum] = safecallForArgNum
		return safecallForArgNum
	end


	setmetatable(XPcallForArgNum, { __index = XPcallForArgNum.CreateForArgNum })

	XPcallForArgNum[0] = function(unsafeFunc, errorhandler)
		return xpcall(unsafeFunc, errorhandler)
	end


	function LibShared.safecallForArgNum1(unsafeFunc, ...)
		-- unsafeFunc is optional. If provided, it must be a function or a callable table.
		if not unsafeFunc then  return  end
		if type(unsafeFunc)~='function' and type(unsafeFunc)~='table' then
			LibShared.softerror("Usage: safecall(unsafeFunc):  function or callable table expected, got "..type(unsafeFunc))
			return
		end

		-- Called xpcall.. cause the 2nd parameter is the errorhandler, as in xpcall(), but *not* in safecall().
		local xpcallForArgNum = XPcallForArgNum[ select('#',...) ]
		-- Do the call through xpcallForArgNum. Avoid tailcall with select(1,...).
		return select( 1, xpcallForArgNum(unsafeFunc, LibShared.errorhandler, ...) )
	end

end -- LibShared.safecallForArgNum1


