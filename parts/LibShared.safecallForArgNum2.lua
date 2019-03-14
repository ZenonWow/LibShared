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
	G.assert(LibShared.errorhandler, 'Include "LibShared.errorhandler.lua" before.')
	G.assert(LibShared.softerror, 'Include "LibShared.softassert.lua" before.')


	local XPcallForArgNum = {}

	local createXPcallForArgNum = [===[
		callback, errorhandler, ARGS = ...
		local function functionClosure()  return select( 1, callback(ARGS) )  end
		return xpcall(functionClosure, errorhandler)
	]===]

	function XPcallForArgNum:CreateForArgNum2(argNum)
		local ARGS = {}
		for i = 1,argNum do  ARGS[i] = "a"..i  end
		local sourcecode = createXPcallForArgNum:gsub("ARGS", G.table.concat(ARGS, ","))
		local xpcallForArgNum = G.assert( G.loadstring(sourcecode, "XPcallForArgNum[argNum="..argNum.."]") )
		self[argNum] = xpcallForArgNum
		return xpcallForArgNum
	end


	setmetatable(XPcallForArgNum, { __index = XPcallForArgNum.CreateForArgNum })

	XPcallForArgNum[0] = function(unsafeFunc, errorhandler)
		return xpcall(unsafeFunc, errorhandler)
	end


	function LibShared.safecallForArgNum2(unsafeFunc, ...)
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

end -- LibShared.safecallForArgNum2


