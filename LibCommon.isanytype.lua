local _G, LibCommon = _G, LibCommon or {}
_G.LibCommon = LibCommon

-- Imports
local UpgradeCheck = assert(LibCommon and LibCommon.UpgradeCheck, "LibCommon.isanytype requires LibCommon.UpgradeCheck")

-- Upvalued Lua globals
local type,select = type,select


-----------------------------
--- LibCommon.isanytype(value, t1, t2, t3, ...):  Test if value is one of 3 (or more) types.
-- @param value - any value to test
-- @param t1..t* - names of accepted types
-- @return value if its type is accepted,  otherwise nil
UpgradeCheck.isanytype[1] = function(value, t1, t2, t3, ...)
	local t = type(value)
	if t == t1 or t == t2 or t == t3 then  return value  end
	if not ... then  return nil  end

	for i = 1,select('#',...) do
		if t == select(i,...) then  return value  end
	end
	return nil
end


