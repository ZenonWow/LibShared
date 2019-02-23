local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

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
LibCommon.iscallable = LibCommon.iscallable or  function(value, notFunction)
	local t = type(value)
	if t=='function' then  return not notFunction and value  end
	if t~='table' and t~='userdata' then  return false  end
	local meta = getmetatable(value)
	return type(meta)=='table' and type(meta.__call)=='function'  and value
end
-- Lua 5.1 won't accept  meta.__call  if it's a callable object, no need to check recursively.


-----------------------------
--- LibCommon.iscallobj(value):  Test if value is a table that can be called like a function.
-- @param value - any value to test
-- @return value if value has a metatable with __call function
-- LibCommon.iscallobj = LibCommon.iscallobj or  function(value)  return LibCommon.iscallable(value, true)  end

--[[
LibCommon.iscallobj = LibCommon.iscallobj or  function(value)
	local t = type(value)
	if t~='table' and t~='userdata' then  return  false  end
	local meta = getmetatable(value)
	return type(meta)=='table' and type(meta.__call)=='function'  and value
end
--]]

