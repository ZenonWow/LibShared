local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

G.assert(LibShared.Revisions, 'Include "LibShared.Revisions.lua" before.')

-- GLOBALS:
-- Used from _G:  DEVMODE, geterrorhandler
-- Used from LibShared:  Revisions, [softassert (in DEVMODE)]
-- Exported to LibShared:  UpgradeObject

-- Upvalued Lua globals:
local rawset,type = rawset,type


-----------------------------
-- local FEATURE_NAME, FEATURE_VERSION = ..
-- local Feature, oldversion = LibShared:UpgradeObject(FEATURE_NAME, FEATURE_VERSION)
-- if Feature then  ..  end
--
-- function LibShared.Define.UpgradeObject(LibShared, feature, newversion)
-- function Define.LibShared.UpgradeObject(LibShared, feature, newversion)
--
LibShared.UpgradeObject = LibShared.UpgradeObject or  function(LibShared, feature, newversion)
	local oldversion = LibShared.Revisions[feature]
	if oldversion < newversion then
		local value = LibShared[feature]

		if type(value)~='table' then
			if value and G.DEVMODE then  LibShared.softassert(false, "Warn: LibShared:UpgradeObject("..feature..", "..newversion.."):  Upgraded feature is not a table, but a "..type(value) )  end
			value = {}
			LibShared[feature] = value
			-- rawset(LibShared, feature, value)
			-- LibShared.Override[feature] = value
		end

		LibShared.Revisions:_Upgrade(feature, value, newversion)
		-- Note:  the order of return values is consistent with LibStub:NewLibrary()
		-- But the opposite of LibShared:UpgradeFunction() which returns oldversion first.
		-- It would be possible to swap these and be consistent with :UpgradeFunction() UpgradeFeature
		return value, oldversion
	end
end


