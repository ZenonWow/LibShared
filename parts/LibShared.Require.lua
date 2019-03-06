local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  geterrorhandler, tostring
-- Used from LibShared:
-- Exported to LibShared:  Require

-- Localized Lua globals:  (used only in "main chunk", not in functions, therefore not upvalued)
local setmetatable = setmetatable

-- Upvalued Lua globals:
-- local rawget = rawget


--[[ Copy-paste import code:
-- Cache in local variable:
local Feature = LibShared.Require.<feature>
Feature(..)
-- Use in-situ:
LibShared.Require.<feature>(..)
--]]


-----------------------------
--- LibShared.Require.<feature>(..)
--- local <Feature> = LibShared.Require.<feature>
-- Use a feature. If feature is missing, raise an error with a helpful message:  '"LibShared.<feature>" has to be loaded before.'
-- Directly using a missing  LibShared.<feature>  would result in the error "attempt to call field '<feature>' (a nil value)"
--
LibShared.Require = LibShared.Require  or setmetatable({ _inTable = LibShared }, {
	__newindex = function(Require, feature, newvalue)  G.geterrorhandler()("Usage:  local <Feature> = LibShared.Require."..G.tostring(feature) )  end,
	__index    = function(Require, feature)
		local value = Require._inTable[feature]
		if value == nil then  error('Executed code requires "LibShared.'..feature..'" to be loaded before.')  end
		return value
	end,
})


