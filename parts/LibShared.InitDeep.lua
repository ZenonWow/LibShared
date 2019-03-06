local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  tostring
-- Used from LibShared:  errorhandler
-- Exported to LibShared:  InitDeep

-- Localized Lua globals:  (used only in "main chunk", not in functions, therefore not upvalued)
local setmetatable = setmetatable

-- Upvalued Lua globals:
local type = type
-- local rawset = rawset


--[[ Copy-paste usage:
-- Recursive table creation:
LibShared.InitDeep(LibUnhook).RawHooks[LibStub].NewLibrary[hookOwner] = hooks.UpdateSpec
--]]



-----------------------------
--- LibShared.InitDeep.<feature> = <Feature>
--
-- Initialize subtables, like LibShared.InitTable, but multi-level, and set a value at the far end.
--  LibShared.InitDeep(RootTable).SubTable1.SubTable2.SubTable3.valueDeepInATree = ..
-- Just initialize the tables and return the last, without setting a field value:
--  local subSubSubTable = LibShared.InitDeep(RootTable).SubTable1.SubTable2.SubTable3()
--  LibShared.InitDeep(RootTable).SubTable1.SubTable2.SubTable3()
--
if  not LibShared.InitDeep  then

	local function checkTable(proxy)
		local node = proxy._currentNode
		if  node == nil  and  proxy._parentTable  then
			node = {}
			proxy._currentNode = node
			proxy._parentTable[proxy._parentKey] = node
		elseif type(node)~='table' then
			-- Current table node is primitive/literal value, not a table.
			-- Report only once per InitDeep().
			if node ~= nil then  LibShared.errorhandler("LibShared.InitDeep traversed to a non-table value in field '"..G.tostring(proxy._parentKey).."' value '"..G.tostring(proxy._currentNode).."'.")  end
			wipe(proxy)
			return false
		end
		return node
	end

	local InitDeepMeta = {
		__call = function(proxy)
			-- End of line, return current table.
			local lastNode = proxy._currentNode
			-- Init the last node as a table if it was unset.
			if lastNode == nil then  lastNode = checkTable(proxy)  end
			wipe(proxy)  -- Reset for next InitDeep().
			return lastNode
		end,
		__index = function(proxy, feature)
			if not checkTable(proxy) then  return nil  end
			local newnode = proxy._currentNode[feature]
			--[[
			if newnode == nil then
				newnode = {}
				proxy._currentNode[feature] = newnode
			end
			--]]
			proxy._parentTable = proxy._currentNode
			proxy._parentKey = feature
			proxy._currentNode = newnode
		end,
		__newindex = function(proxy, feature, firstvalue)
			if firstvalue == nil then  return  end
			local node = checkTable(proxy)
			if not node then  return nil  end
			if  node[feature] ~= nil  then  return  end
			node[feature] = firstvalue
			-- rawset(node, feature, firstvalue)
			-- No reset: allow reusing the last proxy to add more fields, until the next InitDeep(). This might change.
			-- wipe(proxy)
		end,
	})

	InitDeepMeta.proxy = setmetatable({}, InitDeepMeta)

	LibShared.InitDeep = LibShared.InitDeep or function(rootTable)
		InitDeepMeta.proxy._currentNode = rootTable
		return InitDeepMeta.proxy
	end

end


