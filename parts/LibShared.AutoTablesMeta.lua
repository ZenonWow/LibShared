local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:  setmetatable, error, 
-- Used from LibCommon:
-- Exported to LibCommon:  AutoTablesMeta, ConstEmptyTable
-- Upvalued Lua globals:


--[[ Copy-paste import code:
local AutoTablesMeta = LibCommon.Require.AutoTablesMeta
--]]



-----------------------------
--- LibCommon. AutoTablesMeta:  metatable that auto-creates empty inner tables when first referenced.
--
LibCommon.AutoTablesMeta = LibCommon.AutoTablesMeta or { __index = function(self, key)  if key ~= nil then  local v={} ; self[key]=v ; return v  end  end }

-- Non-Lua:  local AutoTablesMeta = { __index = function(self, key)  return key ~= nil and self[key] = {} or nil  end }



-----------------------------
--- LibCommon. ConstEmptyTable:  Constant empty table to use as a default table in places where nil would cause an error.
--
LibCommon.ConstEmptyTable = LibCommon.ConstEmptyTable  or _G.setmetatable({}, { __newindex = function()  _G.error("Can't add properties to the ConstEmptyTable.")  end, __metatable = "ConstEmptyTable is not to be modified." })


