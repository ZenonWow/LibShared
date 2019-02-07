local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME]
assert(LibCommon and LibCommon.Define, 'Include "LibCommon.Define.lua" before.')

-- GLOBALS:
-- Used from _G:
-- Used from LibCommon:
-- Exported to LibCommon:  isanytype

-- Upvalued Lua globals:
local type,select = type,select


-----------------------------
--- LibCommon.isanytype(value, t1, t2, t3, ...):  Test if value is one of 3 (or more) types.
-- @param value - any value to test
-- @param t1..t* - names of accepted types
-- @return value if its type is accepted,  otherwise nil
--
LibCommon.Define.isanytype = function(value, t1, t2, t3, ...)
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

