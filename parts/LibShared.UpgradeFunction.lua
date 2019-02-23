local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

assert(LibShared.Revisions, 'Include "LibShared.Revisions.lua" before.')

-- GLOBALS:
-- Used from _G:
-- Used from LibShared:  Revisions
-- Exported to LibShared:  UpgradeFunction

-- Upvalued Lua globals:
local rawset = rawset


-----------------------------
--- LibShared:UpgradeFunction('<feature>', newversion, function(..)  ..  end)
-- For simpler syntax use:  LibShared.Upgrade.<feature>[newversion] = function(..)  ..  end
--
--  If extra actions are to be taken:
-- local FEATURE_NAME, FEATURE_VERSION = ..
-- if LibShared:UpgradeFunction(FEATURE_NAME, FEATURE_VERSION) then
--   ..  -- initialization
--   local Feature = function(..)  ..  end
--   LibShared:UpgradeFunction(FEATURE_NAME, FEATURE_VERSION, Feature)
-- end
--
LibShared.UpgradeFunction = LibShared.UpgradeFunction or  function(LibShared, feature, newversion, newimpl)
	local oldversion = LibShared.Revisions[feature]
	if oldversion < newversion then
		local oldimpl = LibShared[feature]  --  or  true
		if newimpl then
			LibShared[feature] = newimpl
			-- rawset(LibShared, feature, newimpl)
			rawset(LibShared.Revisions, feature, newversion)
		end
		return oldversion, oldimpl
		-- Note:  LibStub:NewLibrary() and LibShared:UpgradeObject() return these in the opposite order.
		-- This is not useful here as  oldimpl == nil  would break the common check:
		-- if LibShared:UpgradeFunction(feature, 1) then  ..  end
		-- It would work for UpgradeObject() to return oldversion, value.
	end
end


