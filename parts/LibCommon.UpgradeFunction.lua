local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME]
assert(LibCommon and LibCommon.Define, 'Include "LibCommon.Define.lua" before.')

-- GLOBALS:
-- Used from _G:
-- Used from LibCommon:  Require, Versions
-- Exported to LibCommon:  UpgradeFunction

-- Upvalued Lua globals:
local rawset = rawset


-----------------------------
--- LibCommon:UpgradeFunction('<feature>', newversion, function(..)  ..  end)
-- For simpler syntax use:  LibCommon.Upgrade.<feature>[newversion] = function(..)  ..  end
--
--  If extra actions are to be taken:
-- local FEATURE_NAME, FEATURE_VERSION = ..
-- if LibCommon:UpgradeFunction(FEATURE_NAME, FEATURE_VERSION) then
--   ..  -- initialization
--   local Feature = function(..)  ..  end
--   LibCommon:UpgradeFunction(FEATURE_NAME, FEATURE_VERSION, Feature)
-- end
--
LibCommon.Define.UpgradeFunction = function(LibCommon, feature, newversion, newimpl)
	local oldversion = LibCommon.Require.Versions[feature]
	if oldversion < newversion then
		local oldimpl = LibCommon[feature]  --  or  true
		if newimpl then
			LibCommon[feature] = newimpl
			-- rawset(LibCommon         , feature, newimpl)
			rawset(LibCommon.Versions, feature, newversion)
		end
		return oldversion, oldimpl
		-- Note:  LibStub:NewLibrary() and LibCommon:UpgradeObject() return these in the opposite order.
		-- This is not useful here as  oldimpl == nil  would break the common check:
		-- if LibCommon:UpgradeFunction(feature, 1) then  ..  end
		-- It would work for UpgradeObject() to return oldversion, value.
	end
end


