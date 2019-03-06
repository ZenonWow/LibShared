local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  setmetatable, error
-- Used from LibShared:
-- Exported to LibShared:  AutoTablesMeta, ConstEmptyTable
-- Upvalued Lua globals:


--[[ Copy-paste import code:
local AutoTablesMeta = LibShared.Require.AutoTablesMeta
--]]



-----------------------------
--- LibShared. ConstEmptyTable:  Constant empty table to use as a default table in places where nil would cause an error.
--
LibShared.ConstEmptyTable = LibShared.ConstEmptyTable  or G.setmetatable({}, { __newindex = function()  G.error("Can't add properties to the ConstEmptyTable.")  end, __metatable = "ConstEmptyTable is not to be modified." })
local ConstEmptyTable = LibShared.ConstEmptyTable



-----------------------------
--- LibShared. InitTable():  function that looks up a path of keys in a table and auto-creates empty inner tables when the key is not initialized.
-- @return  last table on the path.
-- Usage:  InitTable(root, 'level1', 'level2', 'level3')
-- Returns  root.level1.level2.level3 , creating them as empty tables, if necessary.
--
LibShared.InitTable = LibShared.InitTable  or  function(self, ...)
	for i = 1, select('#',...) do
		local key = select(i,...)
		local subTable = self[key]
		if subTable==nil then
			subTable = {}
			self[key] = subTable
		end
		self = subTable
	end
  return self
end



-----------------------------
--- LibShared. QueryTable():  function that looks up a path of keys in a table.
-- @return  last table on the path, or ConstEmptyTable if its not initialized.
-- Usage:  InitTable(root, 'level1', 'level2', 'level3')
-- Returns  root.level1.level2.level3 , or ConstEmptyTable if one level is not created.
--
LibShared.QueryTable = LibShared.QueryTable  or  function(self, ...)
	for i = 1, select('#',...) do
		local key = select(i,...)
		self = self[key]
		if self==nil then  return ConstEmptyTable  end
	end
  return self
end



-----------------------------
--- LibShared. DeepGet():  function that looks up a path of keys in a tableand returns the value on the last leaf.
-- @return  last value on the path, or nil if its not initialized.
-- Usage:  DeepGet(root, 'level1', 'level2', 'level3')
-- Returns  root.level1.level2.level3 , or nil if one level is not created.
--
LibShared.DeepGet = LibShared.DeepGet  or  function(self, ...)
	for i = 1, select('#',...) do
		local key = select(i,...)
		self = self[key]
		if self==nil then  return nil  end
	end
  return self
end



-----------------------------
--- LibShared. InitTableMeta:  metatable that looks up a path of keys in a table and auto-creates empty inner tables when the key is not initialized.
-- @return  last table on the path.
-- Usage:  root('level1', 'level2', 'level3')
LibShared.InitTableMeta = LibShared.InitTableMeta or { __call = LibShared.InitTable }



-----------------------------
--- LibShared. QueryTableMeta:  metatable that looks up a path of keys in a table when called with the keys as arguments.
-- @return  empty table  if indexed with non-existent key.
-- Usage:  root('level1', 'level2', 'level3')
LibShared.QueryTableMeta = LibShared.QueryTableMeta or { __call = LibShared.QueryTable }



-----------------------------
--- LibShared. AutoTablesCallMeta:  metatable that auto-creates empty inner tables when called with the key (not indexed).
-- @return  empty table  if indexed with non-existent key.
--
LibShared.AutoTablesCallMeta = LibShared.AutoTablesCallMeta or { __call = function(self, ...)
  local create =  ... == true
	if create
	then  return LibShared.InitTable(self, select(2,...))
	else  return LibShared.QueryTable(self, ...)
	end
end }



-----------------------------
--- LibShared. AutoTablesMeta:  metatable that auto-creates empty inner tables when first referenced.
LibShared.AutoTablesMeta = LibShared.AutoTablesMeta or { __index = function(self, key)  if key~=nil then  local v={} ; self[key]=v ; return v  end  end }

-- Non-Lua:  local AutoTablesMeta = { __index = function(self, key)  return key~=nil and (self[key]={}) or nil  end }


