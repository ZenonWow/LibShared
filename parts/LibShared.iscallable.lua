local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:
-- Used from LibShared:
-- Exported to LibShared:  iscallable, iscallobj

-- Upvalued Lua globals:
local type,getmetatable = type,getmetatable


-----------------------------
--- LibShared.iscallable(value):  Test if value can be called like a function.
-- @param value - any value to test
-- @return value if value if a function or an object with __call defined in its metatable
LibShared.iscallable = LibShared.iscallable or  function(value, notFunction)
	local t = type(value)
	if t=='function' then  return not notFunction and value  end
	if t~='table' and t~='userdata' then  return false  end
	local meta = getmetatable(value)
	return type(meta)=='table' and type(meta.__call)=='function'  and value
end
-- Lua 5.1 won't accept  meta.__call  if it's a callable object, no need to check recursively.


-----------------------------
--- LibShared.iscallobj(value):  Test if value is a table that can be called like a function.
-- @param value - any value to test
-- @return value if value has a metatable with __call function
-- LibShared.iscallobj = LibShared.iscallobj or  function(value)  return LibShared.iscallable(value, true)  end

--[[
LibShared.iscallobj = LibShared.iscallobj or  function(value)
	local t = type(value)
	if t~='table' and t~='userdata' then  return  false  end
	local meta = getmetatable(value)
	return type(meta)=='table' and type(meta.__call)=='function'  and value
end
--]]

