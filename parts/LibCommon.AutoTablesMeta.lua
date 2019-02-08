local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:
-- Used from LibCommon:
-- Exported to LibCommon:  AutoTablesMeta
-- Upvalued Lua globals:


--[[ Copy-paste import code:
local AutoTablesMeta = LibCommon.Require.AutoTablesMeta
--]]


-----------------------------
--- LibCommon. AutoTablesMeta:  metatable that auto-creates empty inner tables when first referenced.
--
LibCommon.AutoTablesMeta = LibCommon.AutoTablesMeta or { __index = function(self, key)  if key ~= nil then  self[key] = {}  end  ;  return self[key]  end }

-- Non-Lua:  local AutoTablesMeta = { __index = function(self, key)  return key ~= nil and self[key] = {} or nil  end }


