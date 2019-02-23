local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  tostring, geterrorhandler
-- Used from LibShared:
-- Exported to LibShared:  Revisions

-- Localized Lua globals:  (used only in "main chunk", not in functions, therefore not upvalued)
local setmetatable = setmetatable

-- Upvalued Lua globals:


--[[ Copy-paste usage:
-- Upgrade a feature:
if LibShared.Revisions.MyFeature < FEATURE_VERSION then
  local MyFeature = ..
	LibShared.Upgrade.MyFeature[FEATURE_VERSION] = MyFeature
end
--]]



-----------------------------
-- LibShared.Revisions.<feature> == defined version of LibShared.<feature>  or 0 if present, but no version defined  or -1 if not present.
--
LibShared.Revisions = LibShared.Revisions  or setmetatable({ _namespace = LibShared }, {
	__newindex = function(Revisions, feature, newvalue)  _G.geterrorhandler()("To define a versioned feature use:  LibShared.Upgrade.".._G.tostring(feature).."[newversion] = ..")  end,
	__index    = function(Revisions, feature)  return  Revisions._namespace[feature]  and  0  or  -1  end,
})


