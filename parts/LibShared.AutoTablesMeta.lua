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
--- LibShared. AutoTablesMeta:  metatable that auto-creates empty inner tables when first referenced.
--
LibShared.AutoTablesMeta = LibShared.AutoTablesMeta or { __index = function(self, key)  if key ~= nil then  local v={} ; self[key]=v ; return v  end  end }

-- Non-Lua:  local AutoTablesMeta = { __index = function(self, key)  return key ~= nil and self[key] = {} or nil  end }



-----------------------------
--- LibShared. ConstEmptyTable:  Constant empty table to use as a default table in places where nil would cause an error.
--
LibShared.ConstEmptyTable = LibShared.ConstEmptyTable  or G.setmetatable({}, { __newindex = function()  G.error("Can't add properties to the ConstEmptyTable.")  end, __metatable = "ConstEmptyTable is not to be modified." })


