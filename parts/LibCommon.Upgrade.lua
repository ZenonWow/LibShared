local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

assert(LibCommon.initmetatable, 'Include "LibCommon.initmetatable.lua" before.')

-- GLOBALS:
-- Exported to LibCommon:  Upgrade
-- Used from LibCommon:  initmetatable  (only for init)
-- Used from LibCommon:  UpgradeFunction, UpgradeObject
-- Used from _G:  error, tostring


-----------------------------
--- Declare an upgrade to LibCommon.<feature>.
-- Overwrites the registered version of  LibCommon.<feature>.
-- If newvalue is not provided, then it's the caller's task to actually replace the feature.
-- Usage alternatives:
-- 
-- LibCommon.Upgrade.<feature>[newversion] = newvalue
-- 
-- if  LibCommon.Upgrade.<feature>(newversion)  then
--   local Feature = ..
--   LibCommon.Upgrade.<feature>[newversion] = Feature
-- end
-- 
-- local oldversion = LibCommon.Upgrade.<feature>(newversion)
-- if oldversion then
--   LibCommon.Upgrade.<feature>[newversion] = Feature
-- end
-- 
-- @return nil if current implementation is up-to-date,  or the replaced oldversion if it needs upgrading.
--


local FEATURE_NAME, FEATURE_VERSION = 'Upgrade', 1


--[[ Alternative exists-checks:
local oldversion, Upgrade = LibCommon:UpgradeFunction(FEATURE_NAME, FEATURE_VERSION)
if oldversion then
	local Upgrade = Upgrade or {}
	LibCommon:UpgradeFunction(FEATURE_NAME, FEATURE_VERSION, Upgrade)
--
local Upgrade, oldversion = LibCommon:UpgradeObject(FEATURE_NAME, FEATURE_VERSION)
if Upgrade then
--
local oldversion = LibCommon.Revisions.Upgrade
if oldversion < FEATURE_VERSION then
	local Upgrade = LibCommon.InitTable.Upgrade
	LibCommon.Revisions.Upgrade = FEATURE_VERSION
--
if LibCommon.Revisions.Upgrade < FEATURE_VERSION then
	local Upgrade = LibCommon.InitTable.Upgrade
	LibCommon.Revisions.Upgrade = FEATURE_VERSION
--
if not LibCommon.Upgrade then
	local Upgrade = LibCommon.InitTable.Upgrade
--]]


if not LibCommon.Upgrade then
	local Upgrade = LibCommon.Upgrade or {}
	LibCommon.Upgrade = Upgrade

	-- Upvalued Lua globals:
	-- local setmetatable = setmetatable

	local initmetatable = LibCommon.initmetatable

	local UpgradeMeta = initmetatable(Upgrade)
	-- initsubtable(UpgradeMeta)._UpgradeProxy
	-- initsubtable(UpgradeMeta, '_UpgradeProxy')
	UpgradeMeta.UpgradeProxy = UpgradeMeta.UpgradeProxy or {}
	local UpgradeProxy = UpgradeMeta.UpgradeProxy
	local UpgradeProxyMeta = initmetatable(UpgradeProxy)


	-- LibCommon.Upgrade 's metatable

	--- LibCommon.Upgrade.<feature> = ..  modification disallowed.
	function UpgradeMeta.__newindex(Upgrade, feature, value)
		_G.error("Do not modify LibCommon.Upgrade.".._G.tostring(feature).." directly. Usage: LibCommon.Upgrade.<feature>[newversion] = function ... end")
	end

	--- LibCommon.Upgrade.<feature>:  Initiate declaring an upgrade to LibCommon.<feature>
	-- @return a version-checking proxy for LibCommon.<feature>
	-- Stores the feature name for the next  UpgradeProxy[newversion]
	function UpgradeMeta.__index(Upgrade, feature)
		UpgradeProxy._asObject = nil
		UpgradeProxy._upgradedFeature = feature
		return UpgradeProxy
		-- Alternative:  make a throw-away object at each use.
		-- return setmetatable({ _upgradedFeature = feature }, UpgradeProxyMeta)
	end


	function UpgradeProxy:AsObject()
		self._asObject = true
		return self
	end

	-- UpgradeProxy metatable

	function UpgradeProxyMeta.__newindex(UpgradeProxy, newversion, newimpl)
		local feature = UpgradeProxy._upgradedFeature
		UpgradeProxy._upgradedFeature = nil
		return LibCommon:UpgradeFunction(feature, newversion, newimpl)
	end

	function UpgradeProxyMeta.__call(UpgradeProxy, newversion, upgradeObject)
		local feature = UpgradeProxy._upgradedFeature
		UpgradeProxy._upgradedFeature = nil
		if upgradeObject == true or UpgradeProxy._asObject then  return LibCommon:UpgradeObject(feature, newversion, upgradeObject)  end
		return LibCommon:UpgradeFunction(feature, newversion)
	end

	-- UpgradeProxyMeta.__index    = UpgradeProxyMeta.__call
	function UpgradeProxyMeta.__index(UpgradeProxy, newversion)
		local feature = UpgradeProxy._upgradedFeature
		UpgradeProxy._upgradedFeature = nil
		_G.error("Usage: LibCommon.Upgrade."..feature.."("..newversion..") - use function call instead of indexing with version.")
  end


end -- LibCommon.Upgrade


