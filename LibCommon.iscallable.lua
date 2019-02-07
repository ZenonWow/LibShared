local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME]
assert(LibCommon and LibCommon.Define, 'Include "LibCommon.Define.lua" before.')

-- GLOBALS:
-- Used from _G:
-- Used from LibCommon:
-- Exported to LibCommon:  iscallable, iscallobj

-- Upvalued Lua globals:
local type,getmetatable = type,getmetatable


-----------------------------
--- LibCommon.iscallable(value):  Test if value can be called like a function.
-- @param value - any value to test
-- @return value if value if a function or an object with __call defined in its metatable
LibCommon.Define.iscallable = function(value)
	local t = type(value)
	if t~='table' then  return  t=='function'  end
	local meta = getmetatable(value)
	return type(meta)=='table' and type(meta.__call)=='function'  and value
end


-----------------------------
--- LibCommon.iscallobj(value):  Test if value is a table that can be called like a function.
-- @param value - any value to test
-- @return value if value has a metatable with __call function
LibCommon.Define.iscallobj = function(value)
	if type(value)~='table' then  return false  end
	local meta = getmetatable(value)
	return type(meta)=='table' and type(meta.__call)=='function'  and value
end


