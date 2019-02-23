local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:  tostring, geterrorhandler
-- Used from LibCommon:
-- Exported to LibCommon:  Revisions

-- Localized Lua globals:  (used only in "main chunk", not in functions, therefore not upvalued)
local setmetatable = setmetatable

-- Upvalued Lua globals:


--[[ Copy-paste usage:
-- Upgrade a feature:
if LibCommon.Revisions.MyFeature < FEATURE_VERSION then
  local MyFeature = ..
	LibCommon.Upgrade.MyFeature[FEATURE_VERSION] = MyFeature
end
--]]



-----------------------------
-- LibCommon.Revisions.<feature> == defined version of LibCommon.<feature>  or 0 if present, but no version defined  or -1 if not present.
--
LibCommon.Revisions = LibCommon.Revisions  or setmetatable({ _namespace = LibCommon }, {
	__newindex = function(Revisions, feature, newvalue)  _G.geterrorhandler()("To define a versioned feature use:  LibCommon.Upgrade.".._G.tostring(feature).."[newversion] = ..")  end,
	__index    = function(Revisions, feature)  return  Revisions._namespace[feature]  and  0  or  -1  end,
})


