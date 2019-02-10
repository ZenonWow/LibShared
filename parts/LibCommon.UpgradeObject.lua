local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME]
assert(LibCommon and LibCommon.Require, 'Include "LibCommon.Require.lua" before.')
-- assert(LibCommon and LibCommon.Define, 'Include "LibCommon.Define.lua" before.')
LibCommon.Require.Define
LibCommon.Require.Revisions

-- GLOBALS:
-- Used from _G:  DEVMODE, geterrorhandler
-- Used from LibCommon:  Require, Define  (only for init)
-- Used from LibCommon:  Revisions
-- Exported to LibCommon:  UpgradeObject

-- Upvalued Lua globals:
local rawset,type = rawset,type


-----------------------------
-- local FEATURE_NAME, FEATURE_VERSION = ..
-- local Feature, oldversion = LibCommon:UpgradeObject(FEATURE_NAME, FEATURE_VERSION)
-- if Feature then  ..  end
--
-- function LibCommon.Define.UpgradeObject(LibCommon, feature, newversion)
-- function Define.LibCommon.UpgradeObject(LibCommon, feature, newversion)
--
LibCommon.Define.UpgradeObject = function(LibCommon, feature, newversion)
	local oldversion = LibCommon.Revisions[feature]
	if oldversion < newversion then
		local value = LibCommon[feature]

		if type(value)~='table' then
			if value and _G.DEVMODE then  _G.geterrorhandler()( "Warn: LibCommon:UpgradeObject("..feature..", "..newversion.."):  Upgraded feature is not a table, but a "..type(value) )  end
			value = {}
			LibCommon[feature] = value
			-- rawset(LibCommon, feature, value)
			-- LibCommon.Override[feature] = value
		end

		rawset(LibCommon.Revisions, feature, newversion)
		-- Note:  the order of return values is consistent with LibStub:NewLibrary()
		-- But the opposite of LibCommon:UpgradeFunction() which returns oldversion first.
		-- It would be possible to swap these and be consistent with :UpgradeFunction() UpgradeFeature
		return value, oldversion
	end
end


