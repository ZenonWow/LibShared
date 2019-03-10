local G, LIB_NAME, LIB_REVISION  =  _G, 'LibDispatch', 1
assert(LibStub and LibStub.NewLibraryPart, 'Include "LibStub.NewLibraryPart.lua" before LibDispatch.')
local LibDispatch = LibStub:NewLibraryPart(LIB_NAME, LIB_REVISION, 'CallWrapperDynamic')

-- GLOBALS:
-- Exported to LibDispatch:  CallWrapper, CallWrapperDynamic


------------------------------
--- LibDispatch. CallWrapperDynamic(...):  Create a function/method wrapper that stores the arguments for a callback function.
--
if LibDispatch then

	-- Upvalued Lua globals
	local type,select,unpack = type,select,unpack

	function LibDispatch.CallWrapperDynamic(...)
		local callback, selfArg
		local functionClosure, methodClosure
		local argNum = select('#',...)

		if  0 == argNum  then
			methodClosure   = function()  callback(selfArg)  end
		elseif  1 == argNum  then
			local arg1 = ...
			functionClosure = function()  callback(arg1)  end
			methodClosure   = function()  callback(selfArg, arg1)  end
		else
			-- Pack the parameters into an array.
			local args = {...}
			-- Unpack the parameters in the closure.
			functionClosure = function()  callback( unpack(args,1,argNum) )  end
			methodClosure   = function()  callback( selfArg, unpack(args,1,argNum) )  end
		end

		function closureCreator(calledFunc, self)
			assert( type(calledFunc)=='function' or type(calledFunc)=='table',  "Usage: closureCreator(calledFunc, self):  `calledFunc` - expected function or callable table, got "..type(self) , 2 )
			assert( self==nil or type(self)=='table' or type(self)=='userdata', "Usage: closureCreator(calledFunc, self):  `self` - expected object (table/userdata), got "..type(self) , 2 )
			callback, selfArg = calledFunc, self
			return  selfArg~=nil  and  methodClosure  or  functionClosure  or  calledFunc
		end
		return closureCreator
	end

end -- LibDispatch.CallWrapperDynamic



LibDispatch.CallWrapper = LibDispatch.CallWrapper or LibShared.CallWrapperDynamic


