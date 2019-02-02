local _G, LibCommon = _G, LibCommon or {}
_G.LibCommon = LibCommon

-- Upvalued Lua globals
local type,getmetatable = type,getmetatable


-----------------------------
--- LibCommon.iscallable(value):  Test if value can be called like a function.
-- @param value - any value to test
-- @return value if value if a function or an object with __call defined in its metatable
LibCommon.iscallable = LibCommon.iscallable  or function(value)
	local t = type(value)
	if t~='table' then  return  t=='function'  end
	local mt = getmetatable(value)
	return type(mt)=='table' and type(mt.__call)=='function'  and value
end


-----------------------------
--- LibCommon.iscallobj(value):  Test if value is a table that can be called like a function.
-- @param value - any value to test
-- @return value if value has a metatable with __call function
LibCommon.iscallobj = LibCommon.iscallobj  or function(value)
	if type(value)~='table' then  return false  end
	local mt = getmetatable(value)
	return type(mt)=='table' and type(mt.__call)=='function'  and value
end


