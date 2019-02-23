local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  tostring
-- Used from LibShared:
-- Exported to LibShared:  InitTable

-- Localized Lua globals:  (used only in "main chunk", not in functions, therefore not upvalued)
local setmetatable = setmetatable

-- Upvalued Lua globals:
-- local rawset = rawset


--[[ Copy-paste usage:
-- Shared table created at first definition:
local MyFeatureTable = LibShared.InitTable.MyFeatureTable
MyFeatureTable.<field> = MyFeatureTable.<field> or ..
--]]



--[[
-----------------------------
LibShared.InitTable = LibShared.InitTable  or setmetatable({ _inTable = LibShared }, {
	__newindex = function(InitTable, feature, newvalue)
		return _G.geterrorhandler()("Usage:  local SharedTable = LibShared.InitTable.".._G.tostring(feature) )
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
--  local SharedTable = LibShared.InitTable.SharedTable
-- @return  nil  if  LibShared.SharedTable has a non-table value.
-- Same as:
--  local SharedTable = LibShared.InitDeep.SharedTable()
-- .. without the function call and the possibility to traverse multiple levels.
--
if not LibShared.InitTable then

	local InitTableMeta = {
		__newindex = function(InitTable, feature, newvalue)
			_G.geterrorhandler()("Usage:  local SharedTable = LibShared.InitTable.".._G.tostring(feature) )
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

	LibShared.InitTable = LibShared.InitTable  or setmetatable({ _inTable = LibShared }, InitTableMeta)

end -- if not LibShared.InitTable


