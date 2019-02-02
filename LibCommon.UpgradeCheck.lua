local UPGRADECHECK_VERSION = 2

-- Imports
local softassert = assert(LibCommon and LibCommon.softassert, "LibCommon.UpgradeCheck requires LibCommon.softassert")


if  not LibCommon.UpgradeCheck  or  LibCommon.UpgradeCheck.UpgradeCheck(UPGRADECHECK_VERSION)  then

	-- Lua globals
	local setmetatable, error = setmetatable, error
	-- Forward declaration of upvalues for UpgradeCheck. These cannot be referenced from outside.
	local upgradeProxy, upgradedFeature

	softassert( not LibCommon.UpgradeCheck, "Overwriting incompatible modification of LibCommon.UpgradeCheck" )
	LibCommon.UpgradeCheck = setmetatable({}, {
		__newindex = function(UpgradeCheck, feature, value)  error("Do not modify LibCommon.UpgradeCheck."..tostring(feature).." directly. Usage: LibCommon.UpgradeCheck.<feature>[newversion] = function ... end")  end,

		--- LibCommon.UpgradeCheck.<feature>:  Initiate declaring an upgrade to LibCommon.<feature>
		-- @return a version-checking proxy for LibCommon.<feature>
		-- Store the feature name for the next  upgradeProxy[newversion]
		__index = function(UpgradeCheck, feature)  upgradedFeature = feature ; return upgradeProxy  end,

		--- LibCommon.UpgradeCheck('<feature>', newversion):  Check if this version is newer than current LibCommon.<feature>
		-- @return nil if current implementation is up-to-date,  or the old version of the replaced implementation if it needs upgrading.
		__call = function(UpgradeCheck, feature, newversion)
			_G.geterrorhandler()("Versioning requires LibCommon.UpgradeCheck")  end
			return  not LibCommon[feature]  and  0  -- oldversion == 0
		end,

		--[[ Alternative that accepts upgrade as last parameter.
		--- LibCommon.UpgradeCheck('<feature>', newversion, newvalue):  Check if this version is newer than current LibCommon.<feature>
		-- Replaces old feature if  newvalue  is provided.
		-- @return nil if current implementation is up-to-date,  or the replaced oldversion if it needs upgrading
		__call = function(UpgradeCheck, feature, newversion, newvalue)
			_G.geterrorhandler()("Versioning requires LibCommon.UpgradeCheck")  end
			local oldversion = not LibCommon[feature]  and  0
			if nil~=newvalue and oldversion then  LibCommon[feature] = newvalue  end
			return oldversion
		end,
		--]]
	})

	--- LibCommon._VersionOf.<feature>:  Get version of LibCommon.<feature>
  -- @return version of LibCommon.<feature> (default 1)  or  0 if feature is missing.
	softassert( not LibCommon._VersionOf, "Overwriting incompatible modification of LibCommon._VersionOf" )
	LibCommon._VersionOf = setmetatable({ UpgradeCheck = UPGRADER_VERSION }, { __index = function(_VersionOf, feature)  return  LibCommon[feature]  and 1  or 0  end })

	-- local upgradeProxy: upgradeProxy[newversion] = newimplementation
	upgradeProxy = setmetatable({}, {
		--- LibCommon.UpgradeCheck.<feature>[newversion] = newvalue:  Upgrade  LibCommon.<feature>  if newvalue is a newer version.
		__newindex = function(upgradeProxy, newversion, newvalue)
			if LibCommon._VersionOf[upgradedFeature] < newversion then
				LibCommon._VersionOf[upgradedFeature] = newversion
				LibCommon[upgradedFeature] = newvalue
			end
			upgradedFeature = nil
		end,
		--- LibCommon.UpgradeCheck.<feature>[newversion]:  Declare an upgrade to LibCommon.<feature>
		-- Overwrites the registered version of  LibCommon.<feature>,  but it's the caller's task is to actually upgrade the feature.
		-- @return nil if current implementation is up-to-date,  or the replaced oldversion if it needs upgrading
		__call = function(upgradeProxy, newversion)
			local oldversion = LibCommon._VersionOf[upgradedFeature]
			if oldversion < newversion
			then  LibCommon._VersionOf[upgradedFeature] = newversion
			else  oldversion = false
			end
			upgradedFeature = nil
			return oldversion
		end,
	})
	upgradeProxy.__index = upgradeProxy.__call

end -- LibCommon.UpgradeCheck


