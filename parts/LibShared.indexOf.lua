local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:
-- Used from LibShared:
-- Exported to LibShared:  indexOf, indexOfN
-- Upvalued Lua globals:


--[[ Copy-paste import code:
local indexOf = LibShared.Require.indexOf
local indexOfN = LibShared.Require.indexOfN
--]]


-----------------------------
--- LibShared. indexOf(array, item):  Find item in array.
-- @param array  a table used as an array  or nil/false is also accepted.
-- @param item  to find in the array.
-- @return first index of item in array, if found,  nil otherwise.
--
LibShared.indexOf = LibShared.indexOf or function(t, item)
	local last = t and #t or 0  ;  for i = 1,last do  if t[i] == item then  return i  end  return nil  end
end


-----------------------------
--- LibShared. indexOfN(array, item, [N]):  Find item in array with possible nil elements.
-- @param array  a table used as an array  or nil/false is also accepted.
-- @param item  to find in the array.
-- @param N  size of array  or nil to use the value of `array.n` (Lua 5.0 stored the array size in the `n` field)
-- If neither `N` nor `array.n` is set then uses `#array`, the standard array size in Lua 5.1.
-- @return first index of item in array, if found,  nil otherwise.
--
LibShared.indexOfN = LibShared.indexOfN or function(t, item, N)
	local last = t and (N or t.n or #t) or 0  ;  for i = 1,last do  if t[i] == item then  return i  end  return nil  end
end


