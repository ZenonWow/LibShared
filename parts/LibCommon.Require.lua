local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:  geterrorhandler, tostring
-- Used from LibCommon:
-- Exported to LibCommon:  Require

-- Localized Lua globals:  (used only in "main chunk", not in functions, therefore not upvalued)
local setmetatable = setmetatable

-- Upvalued Lua globals:
-- local rawget = rawget


--[[ Copy-paste import code:
-- Cache in local variable:
local Feature = LibCommon.Require.<feature>
Feature(..)
-- Use in-situ:
LibCommon.Require.<feature>(..)
--]]


-----------------------------
--- LibCommon.Require.<feature>(..)
--- local <Feature> = LibCommon.Require.<feature>
-- Use a feature. If feature is missing, raise an error with a helpful message:  '"LibCommon.<feature>" has to be loaded before.'
-- Directly using a missing  LibCommon.<feature>  would result in the error "attempt to call field '<feature>' (a nil value)"
--
LibCommon.Require = LibCommon.Require  or setmetatable({ _inTable = LibCommon }, {
	__newindex = function(Require, feature, newvalue)  _G.geterrorhandler()("Usage:  local <Feature> = LibCommon.Require.".._G.tostring(feature) )  end,
	__index    = function(Require, feature)
		local value = Require._inTable[feature]
		if value == nil then  error('Executed code requires "LibCommon.'..feature..'" to be loaded before.')  end
		return value
	end,
})


--[[
-----------------------------
-- An explicit mode of checking if a feature is present/loaded:
-- if  LibCommon.Has.<feature>  then  ..  end
-- Easier to search for. If that's of no concern, then:
-- if  LibCommon.<feature>  then  ..  end
-- @return  LibCommon.<feature> if present,  or nil if not loaded yet.
--
LibCommon.Has = LibCommon.Has  or setmetatable({ _inTable = LibCommon }, {
	__newindex = function(Has, feature, newvalue)  _G.geterrorhandler()("Do not modify LibCommon.Has.".._G.tostring(feature))  end,
	-- __index    = function(Has, feature)  return  rawget(Has._inTable, feature)  end,
	__index    = LibCommon,
})
--]]


