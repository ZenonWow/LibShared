local G, LIB_NAME, LIB_REVISION  =  _G, 'LibDispatch', 1
assert(LibStub and LibStub.NewLibraryPart, 'Include "LibStub.NewLibraryPart.lua" before LibDispatch.')
local LibDispatch = LibStub:NewLibraryPart(LIB_NAME, LIB_REVISION, 'CallWrapperForArgNum')

-- GLOBALS:
-- Used from global in code snippet:  type, select
-- Used from _G:  table.concat, assert, print, loadstring  (ca. 5 times)
-- Used from LibShared:  asserttype
-- Exported to LibDispatch:  CallWrapper, CallWrapperForArgNum


------------------------------
--- LibDispatch. CallWrapperForArgNum(...):  Create a function/method wrapper that stores the arguments for a callback function.
--
if LibDispatch then

	-- Upvalued Lua globals:
	local type,select = type,select


	local WrapperCreators = {}

	local wrapperCreatorForArgNum = [===[
		local callback, selfArg
		local ARGS = ...
		local function functionClosure()   return select( 1, callback(ARGS) )   end
		local function methodClosure()     return select( 1, callback(selfArg, ARGS) )   end
	]===]

	local wrapperCreatorForZeroArgs = [===[
		local callback, selfArg
		local function methodClosure()     return select( 1, callback(selfArg) )   end
	]===]

	local wrapperCreatorCommon = [===[
		local function closureCreator(calledFunc, self)
			assert( type(calledFunc)=='function' or type(calledFunc)=='table',  "Usage: closureCreator(calledFunc, self):  `calledFunc` - expected function or callable table, got "..type(self) , 2 )
			assert( self==nil or type(self)=='table' or type(self)=='userdata', "Usage: closureCreator(calledFunc, self):  `self` - expected object (table/userdata), got "..type(self) , 2 )
			callback, selfArg = calledFunc, self
			return  self~=nil  and  methodClosure  or  functionClosure
		end
		return closureCreator
	]===]


	function WrapperCreators:CompileCreator(argNum)
		LibShared.asserttype( argNum, 'number', "Usage: SafecallWrappers[argNum]:  `argNum` - ", 2)
		if argNum == 0 then
			sourcecode = wrapperCreatorForZeroArgs
			local commoncode = wrapperCreatorCommon:gsub("  or  functionClosure", "  or  calledFunc")
			assert(commoncode ~= wrapperCreatorCommon, "WrapperCreators:CompileCreator()  failed to replace `functionClosure` with `calledFunc`")
			sourcecode = sourcecode .. commoncode
		else
			local args = {}
			for i = 1,argNum do  args[i] = "a"..i  end
			local ARGS = G.table.concat(args, ",")
			sourcecode = wrapperCreatorForArgNum:gsub("ARGS", ARGS)
			sourcecode = sourcecode .. wrapperCreatorCommon
		end
		-- TODO: Test if it's faster to return only the first return value:
		-- sourcecode:gsub(" select%( 1,", " true and %(")

		local compiled, msg = G.loadstring(sourcecode, "SafecallWrappers[argNum="..argNum.."]")
		if not compiled then  G.print("WrapperCreators:CompileCreator()  failed to compile:\n" .. sourcecode)  end
		local creator = G.assert(compiled, msg)
		self[argNum] = creator
		return creator
	end


	-- WrapperCreators[0] = wrapperCreatorForZeroArgs
	setmetatable(WrapperCreators, { __index = WrapperCreators.CompileCreator })


	function LibDispatch.CallWrapperForArgNum(...)
		local wrapperCreator = WrapperCreators[ select('#',...) ]
		local closureCreator = wrapperCreator(...)
		return closureCreator
	end

end -- LibDispatch.CallWrapperForArgNum



LibDispatch.CallWrapper = LibDispatch.CallWrapper or LibDispatch.CallWrapperForArgNum


