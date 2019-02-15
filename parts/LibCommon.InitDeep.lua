local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:  geterrorhandler, tostring
-- Used from LibCommon:
-- Exported to LibCommon:  InitDeep

-- Localized Lua globals:  (used only in "main chunk", not in functions, therefore not upvalued)
local setmetatable = setmetatable

-- Upvalued Lua globals:
local type = type
-- local rawset = rawset


--[[ Copy-paste usage:
-- Recursive table creation:
LibCommon.InitDeep(LibUnhook).RawHooks[LibStub].NewLibrary[hookOwner] = hooks.UpdateSpec
--]]



-----------------------------
--- LibCommon.InitDeep.<feature> = <Feature>
--
-- Initialize subtables, like LibCommon.InitTable, but multi-level, and set a value at the far end.
--  LibCommon.InitDeep(RootTable).SubTable1.SubTable2.SubTable3.valueDeepInATree = ..
-- Just initialize the tables and return the last, without setting a field value:
--  local subSubSubTable = LibCommon.InitDeep(RootTable).SubTable1.SubTable2.SubTable3()
--  LibCommon.InitDeep(RootTable).SubTable1.SubTable2.SubTable3()
--
if  not LibCommon.InitDeep  then

	local function checkTable(proxy)
		if type(proxy._inTable)~='table' then
			-- Current table node is primitive/literal value, not a table.  Report only once per InitDeep().
			if proxy._inTable then  _G.geterrorhandler()("LibCommon.InitDeep traversed to a non-table value in field '"..proxy._parentKey.."' value '".._G.tostring(proxy._inTable).."'.")  end
			proxy._inTable = nil
			return false
		end
		return true
	end

	local InitDeepMeta = {
		__call = function(proxy)
			-- End of line, return current table.
			local lastValue = proxy._inTable
			wipe(proxy)  -- Reset for next InitDeep().
			return lastValue
		end,
		__index = function(proxy, feature)
			if not checkTable(proxy) then  return nil  end
			local newroot = proxy._inTable[feature]
			if newroot == nil then
				newroot = {}
				proxy._inTable[feature] = newroot
			end
			-- proxy._parentTable, proxy._parentKey = proxy._inTable, feature
			proxy._parentKey = feature
			proxy._inTable = newroot
		end,
		__newindex = function(proxy, feature, firstvalue)
			if not checkTable(proxy) then  return nil  end
			if  proxy._inTable[feature] ~= nil  then  return  end
			proxy._inTable[feature] = firstvalue
			-- rawset(proxy._inTable, feature, firstvalue)
			-- No reset: allow reusing the last proxy to add more fields, until the next InitDeep(). This might change.
			-- wipe(proxy)
		end,
	})

	InitDeepMeta.proxy = setmetatable({}, InitDeepMeta)

	LibCommon.InitDeep = LibCommon.InitDeep or function(rootTable)
		InitDeepMeta.proxy._inTable = rootTable
		return InitDeepMeta.proxy
	end

end


