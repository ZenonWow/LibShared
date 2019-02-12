local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:
-- Used from LibCommon:
-- Exported to LibCommon:  isanytype

-- Upvalued Lua globals:
local type,select = type,select


-----------------------------
--- LibCommon.istype2(value, t1, t2):  Test if value is one of 2 types.
-- @param value - any value to test
-- @param t1..t2 - names of accepted types
-- @return value if its type is accepted,  otherwise nil
--
LibCommon.istype2 = LibCommon.istype2 or  function(value, t1, t2)
	local t=type(value)  ;  if t==t1 or t==t2 then return value end  ;  return nil
end


-----------------------------
--- LibCommon.istype3(value, t1, t2, t3):  Test if value is one of 3 types.
-- @param value - any value to test
-- @param t1..t3 - names of accepted types
-- @return value if its type is accepted,  otherwise nil
--
LibCommon.istype3 = LibCommon.istype3 or  function(value, t1, t2, t3)
	local t=type(value)  ;  if t==t1 or t==t2 or t==t3 then return value end  ;  return nil
end


-----------------------------
--- LibCommon.isanytype(value, t1, t2, t3, ...):  Test if value is one of 3 (or more) types.
-- @param value - any value to test
-- @param t1..t* - names of accepted types
-- @return value if its type is accepted,  otherwise nil
--
LibCommon.isanytype = LibCommon.isanytype or  function(value, t1, t2, t3, ...)
	local t = type(value)
	if t == t1 or t == t2 or t == t3 then  return value  end
	if not ... then  return nil  end

	for i = 1,select('#',...) do
		if t == select(i,...) then  return value  end
	end
	return nil
end

--[[
LibCommon.Upgrade.isanytype[1] = function()  ..  end
if LibCommon.Upgrade.isanytype[1] then  ..  end
if LibCommon:UpgradeFeature('isanytype', 1, function() .. end) then  ..  end
if LibCommon:UpgradeFeature('isanytype', 1) then  ..  end
--]]


