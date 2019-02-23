local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

assert(LibShared.initmetatable, 'Include "LibShared.initmetatable.lua" before.')

-- GLOBALS:
-- Exported to LibShared:  Upgrade
-- Used from LibShared:  initmetatable  (only for init)
-- Used from LibShared:  UpgradeFunction, UpgradeObject
-- Used from _G:  error, tostring


-----------------------------
--- Declare an upgrade to LibShared.<feature>.
-- Overwrites the registered version of  LibShared.<feature>.
-- If newvalue is not provided, then it's the caller's task to actually replace the feature.
-- Usage alternatives:
-- 
-- LibShared.Upgrade.<feature>[newversion] = newvalue
-- 
-- if  LibShared.Upgrade.<feature>(newversion)  then
--   local Feature = ..
--   LibShared.Upgrade.<feature>[newversion] = Feature
-- end
-- 
-- local oldversion = LibShared.Upgrade.<feature>(newversion)
-- if oldversion then
--   LibShared.Upgrade.<feature>[newversion] = Feature
-- end
-- 
-- @return nil if current implementation is up-to-date,  or the replaced oldversion if it needs upgrading.
--


local FEATURE_NAME, FEATURE_VERSION = 'Upgrade', 1


--[[ Alternative exists-checks:
local oldversion, Upgrade = LibShared:UpgradeFunction(FEATURE_NAME, FEATURE_VERSION)
if oldversion then
	local Upgrade = Upgrade or {}
	LibShared:UpgradeFunction(FEATURE_NAME, FEATURE_VERSION, Upgrade)
--
local Upgrade, oldversion = LibShared:UpgradeObject(FEATURE_NAME, FEATURE_VERSION)
if Upgrade then
--
local oldversion = LibShared.Revisions.Upgrade
if oldversion < FEATURE_VERSION then
	local Upgrade = LibShared.InitTable.Upgrade
	LibShared.Revisions.Upgrade = FEATURE_VERSION
--
if LibShared.Revisions.Upgrade < FEATURE_VERSION then
	local Upgrade = LibShared.InitTable.Upgrade
	LibShared.Revisions.Upgrade = FEATURE_VERSION
--
if not LibShared.Upgrade then
	local Upgrade = LibShared.InitTable.Upgrade
--]]


if not LibShared.Upgrade then
	local Upgrade = LibShared.Upgrade or {}
	LibShared.Upgrade = Upgrade

	-- Upvalued Lua globals:
	-- local setmetatable = setmetatable

	local initmetatable = LibShared.initmetatable

	local UpgradeMeta = initmetatable(Upgrade)
	-- initsubtable(UpgradeMeta)._UpgradeProxy
	-- initsubtable(UpgradeMeta, '_UpgradeProxy')
	UpgradeMeta.UpgradeProxy = UpgradeMeta.UpgradeProxy or {}
	local UpgradeProxy = UpgradeMeta.UpgradeProxy
	local UpgradeProxyMeta = initmetatable(UpgradeProxy)


	-- LibShared.Upgrade 's metatable

	--- LibShared.Upgrade.<feature> = ..  modification disallowed.
	function UpgradeMeta.__newindex(Upgrade, feature, value)
		_G.error("Do not modify LibShared.Upgrade.".._G.tostring(feature).." directly. Usage: LibShared.Upgrade.<feature>[newversion] = function ... end")
	end

	--- LibShared.Upgrade.<feature>:  Initiate declaring an upgrade to LibShared.<feature>
	-- @return a version-checking proxy for LibShared.<feature>
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
		return LibShared:UpgradeFunction(feature, newversion, newimpl)
	end

	function UpgradeProxyMeta.__call(UpgradeProxy, newversion, upgradeObject)
		local feature = UpgradeProxy._upgradedFeature
		UpgradeProxy._upgradedFeature = nil
		if upgradeObject == true or UpgradeProxy._asObject then  return LibShared:UpgradeObject(feature, newversion, upgradeObject)  end
		return LibShared:UpgradeFunction(feature, newversion)
	end

	-- UpgradeProxyMeta.__index    = UpgradeProxyMeta.__call
	function UpgradeProxyMeta.__index(UpgradeProxy, newversion)
		local feature = UpgradeProxy._upgradedFeature
		UpgradeProxy._upgradedFeature = nil
		_G.error("Usage: LibShared.Upgrade."..feature.."("..newversion..") - use function call instead of indexing with version.")
  end


end -- LibShared.Upgrade


