local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:
-- Used from LibShared:
-- Exported to LibShared:  isanytype

-- Upvalued Lua globals:
local type,select = type,select


-----------------------------
--- LibShared.isanytype(value, t1, t2, t3, ...):  Test if value is one of 3 (or more) types.
-- @param value - any value to test
-- @param t1..t* - names of accepted types
-- @return value if its type is accepted,  otherwise nil
--
LibShared.isanytype = LibShared.isanytype or  function(value, ...)
	local t = type(value)
	for i = 1,select('#',...) do
		if t == select(i,...) then  return value  end
	end
	return nil
end

--[[
LibShared.Upgrade.isanytype[1] = function()  ..  end
if LibShared.Upgrade.isanytype[1] then  ..  end
if LibShared:UpgradeFeature('isanytype', 1, function() .. end) then  ..  end
if LibShared:UpgradeFeature('isanytype', 1) then  ..  end
--]]


