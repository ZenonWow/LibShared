local G, LIB_NAME, LIB_REVISION  =  _G, 'LibDispatch', 1
-- assert(LibStub and LibStub.NewLibraryPart, 'Include "LibStub.NewLibraryPart.lua" before LibDispatch.')
-- local LibDispatch = LibStub:NewLibraryPart(LIB_NAME, LIB_REVISION, 'CallWrapper')
assert(LibStub, 'Include "LibStub.lua" before LibDispatch.')
local LibDispatch = LibStub:NewLibrary(LIB_NAME, LIB_REVISION)

-- GLOBALS:
-- Used from LibDispatch:  CallWrapperForArgNum / CallWrapperDynamic
-- Exported to LibDispatch:  CallWrapper


------------------------------
--- LibDispatch. CallWrapper(...):  Create a function/method wrapper that stores the arguments for a callback function.
-- @return  a wrapper function  that wraps a callback function into a closure.
-- The closure is called without arguments.
-- When called, it restores the saved arguments and calls the wrapped callback function with these arguments.
-- Calling wrapper again will overwrite the previous closure. Don't save it for later, it will cause surprises.
-- For efficiency the closure always calls the last wrapped function.
-- This suits the most common usage when callback functions are called once in response to an event.
--
-- -- The following code calls `callback1(a, b, c)` once, then `callback2(a, b, c)` twice, then `obj:method(a, b, c)`:
-- local closureCreator = CallWrapper(a, b, c)
-- local closure = closureCreator(callback1)
-- local result = closure()
-- closure = closureCreator(callback2)
-- result = closure()
-- result = closure()
-- closure = closureCreator(obj.method, obj)
-- result = closure()
-- 
-- Usage for error catching in safecallWrapped():
-- -- Save arguments (parameter values).
-- local closureCreator = CallWrapper(...)
-- local closure = closureCreator(callback)
-- -- Avoid tailcall with select(1,...).
-- return select( 1, xpcall(closure, errorhandler) )
--
if LibDispatch then
	LibDispatch.CallWrapper = nil
		or LibDispatch.CallWrapperForArgNum
		or LibDispatch.CallWrapperDynamic
end


