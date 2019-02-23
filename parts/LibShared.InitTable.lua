local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:  tostring
-- Used from LibCommon:
-- Exported to LibCommon:  InitTable

-- Localized Lua globals:  (used only in "main chunk", not in functions, therefore not upvalued)
local setmetatable = setmetatable

-- Upvalued Lua globals:
-- local rawset = rawset


--[[ Copy-paste usage:
-- Shared table created at first definition:
local MyFeatureTable = LibCommon.InitTable.MyFeatureTable
MyFeatureTable.<field> = MyFeatureTable.<field> or ..
--]]



--[[
-----------------------------
LibCommon.InitTable = LibCommon.InitTable  or setmetatable({ _inTable = LibCommon }, {
	__newindex = function(InitTable, feature, newvalue)
		return _G.geterrorhandler()("Usage:  local SharedTable = LibCommon.InitTable.".._G.tostring(feature) )
	end,
	__index    = function(InitTable, feature)
		local value = InitTable._inTable[feature]
		if value == nil then  value = {}  ;  InitTable._inTable[feature] = value  end
		-- if value == nil then  value = {}  ;  rawset(InitTable._inTable, feature, value)  end
		if type(value)~='table' then  value = nil  end
		return value
	end,
})
--]]



-----------------------------
-- Initialize a table.
--  local SharedTable = LibCommon.InitTable.SharedTable
-- @return  nil  if  LibCommon.SharedTable has a non-table value.
-- Same as:
--  local SharedTable = LibCommon.InitDeep.SharedTable()
-- .. without the function call and the possibility to traverse multiple levels.
--
if not LibCommon.InitTable then

	local InitTableMeta = {
		__newindex = function(InitTable, feature, newvalue)
			_G.geterrorhandler()("Usage:  local SharedTable = LibCommon.InitTable.".._G.tostring(feature) )
		end,
		__index    = function(InitTable, feature)
			local value = InitTable._inTable[feature]
			if value == nil then  value = {}  ;  InitTable._inTable[feature] = value  end
			-- if value == nil then  value = {}  ;  rawset(InitTable._inTable, feature, value)  end
			if type(value)~='table' then  value = nil  end
			return value
		end,
	}
	function InitTableMeta.__call(InitTable, rootTable)
		InitTableMeta.proxyObject._inTable = rootTable
		return InitTableMeta.proxyObject
	end
	InitTableMeta.proxyObject = setmetatable({}, InitTableMeta)

	LibCommon.InitTable = LibCommon.InitTable  or setmetatable({ _inTable = LibCommon }, InitTableMeta)

end -- if not LibCommon.InitTable


