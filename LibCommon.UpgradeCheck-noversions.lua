local UPGRADECHECK_VERSION = 1

local _G, LibCommon = _G, LibCommon or {}
_G.LibCommon = LibCommon


-----------------------------
-- Non-versioning implementation of  LibCommon.UpgradeCheck  that accepts upgrades at first definition (when LibCommon.<feature> is nil).
if  not LibCommon.UpgradeCheck  or  LibCommon.UpgradeCheck.UpgradeCheck(UPGRADECHECK_VERSION)  then

	local function mockProxyCall(proxy, newversion)  return upgradedFeature and 0  end,  -- oldversion == 0
	local mockProxy,upgradedFeature = setmetatable({}, {

		--- LibCommon.UpgradeCheck.<feature>[newversion] = newvalue:  Define  LibCommon.<feature>  if it's missing.
		__newindex = function(proxy, newversion, newvalue)  if upgradedFeature then LibCommon[upgradedFeature] = newvalue  end,

		--- LibCommon.UpgradeCheck.<feature>(newversion)
		--- LibCommon.UpgradeCheck.<feature>[newversion]
		-- Check if  LibCommon.<feature>  is missing.
		-- @return nil if  LibCommon.<feature>  is defined,  or the old version 0 representing a missing feature.
		__call = mockProxyCall,
		__index = mockProxyCall,

	})
	-- @return nil if  LibCommon.<feature>  is defined,  or the old version 0 representing a missing feature.

	local  selfProxy = setmetatable({}, { __index = function(proxy, newversion)  return true  end })
	LibCommon.UpgradeCheck = setmetatable({ UpgradeCheck = selfProxy }, {
		__newindex = function(proxy, newversion, newvalue)  error("Do not modify LibCommon.UpgradeCheck.")  end,

		--- LibCommon.UpgradeCheck.<feature>:  Initiate a definition of  LibCommon.<feature>
		-- @return a proxy that accepts the first definition for  LibCommon.<feature>
		__index = function(UpgradeCheck, feature)
			_G.geterrorhandler()("Versioning requires LibCommon.UpgradeCheck")  end
			upgradedFeature =  not LibCommon[feature]  and  feature
			return mockProxy
		end,

		--- LibCommon.UpgradeCheck('<feature>', newversion):  Check if  LibCommon.<feature>  is missing.
		-- @return nil if  LibCommon.<feature>  is defined,  or the old version 0 representing a missing feature.
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
end



