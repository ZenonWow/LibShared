local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:  geterrorhandler, tostring
-- Used from LibCommon:
-- Exported to LibCommon:  Require, Has
-- Exported mock to LibCommon:  Import

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
-- Or just to check if loaded:
LibCommon.Require.<feature>
--]]



-----------------------------
--- LibCommon.Require.<feature>(..)
-- Use a feature. If feature is missing, raise an error with a helpful message:  '"LibCommon.<feature>" has to be loaded before.'
-- Directly using a missing  LibCommon.<feature>  would result in the error "attempt to call field '<feature>' (a nil value)"
--- local <Feature> = LibCommon.Require.<feature>
LibCommon.Require = LibCommon.Require  or setmetatable({ _namespace = LibCommon }, {
	__newindex = function(Require, feature, newvalue)  _G.geterrorhandler()("Usage:  local <Feature> = LibCommon.Require.".._G.tostring(feature) )  end,
	__index    = function(Require, feature)
		local value = Require._namespace[feature]
		if value == nil then  error('Executed code requires "LibCommon.'..feature..'" to be loaded before.')  end
		return value
	end,
})


-----------------------------
-- To check if a feature is present/loaded, use:
-- if  LibCommon.Has.<feature>  then ..
-- Do not use:
-- if  LibCommon.<feature>  then ..  as it raises an error when a feature is missing.
-- @return  LibCommon.<feature> if present,  or nil if not loaded yet.
--
LibCommon.Has = LibCommon.Has  or setmetatable({ _namespace = LibCommon }, {
	__newindex = function(Has, feature, newvalue)  _G.geterrorhandler()("Do not modify LibCommon.Has.".._G.tostring(feature))  end,
	-- __index    = function(Has, feature)  return  rawget(Has._namespace, feature)  end,
	__index    = LibCommon,
})




-----------------------------
-- Mock implementation of  LibCommon:Import  that reports an error when used, then continues execution.
--- LibCommon:Import("<feature>[,<feature>]*", client or "clientname")
LibCommon.Import = LibCommon.Import or  function(FromLib, features, client, optional, stackdepth)
	-- Signal it's the mock implementation.
	if features == 'Import' then  return nil  end
	-- Importing only one feature (no list of features) that is present won't report an error as a convenience.
	local value = LibCommon[features]
	if value then  return value  end
	_G.geterrorhandler()(_G.tostring(client)..' requires "LibCommon.Import" loaded before.')
end


