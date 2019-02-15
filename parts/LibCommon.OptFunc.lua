local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:  geterrorhandler, tostring
-- Used from LibCommon:
-- Exported to LibCommon:  OptFunc

-- Localized Lua globals:  (used only in "main chunk", not in functions, therefore not upvalued)
local setmetatable = setmetatable

-- Upvalued Lua globals:
local type = type


--[[ Copy-paste import code:
-- Cache in local variable:
local Feature = LibCommon.OptFunc.<feature>
Feature(..)
-- Use in-situ:
LibCommon.Require.<feature>(..)
--]]


-----------------------------
--- LibCommon.OptFunc.<feature>(..)
-- Call a feature function. If the function is not defined, then instead of crashing call the empty  LibCommon.ReturnNil()  function.
--- local result = LibCommon.OptFunc.<feature>(..)
--
LibCommon.OptFunc = LibCommon.OptFunc  or setmetatable({ _inTable = LibCommon }, {
	__newindex = function(OptFunc, feature, newvalue)  _G.geterrorhandler()("Usage:  local result = LibCommon.OptFunc.".._G.tostring(feature).."(..)" )  end,
	__index    = function(OptFunc, feature)
		local value = OptFunc._inTable[feature]
		if type(value)~='function' then
			LibCommon.softassert( type == nil, "Warn: LibCommon.OptFunc."..tostring(feature)..":  expected function, found "..type(value) )
			value = LibCommon.ReturnNil
		end
		return value
	end,
})


-- Dependency from LibCommon.softassert.lua:
LibCommon.softassert = LibCommon.softassert or  function(ok, message)  return ok, ok or _G.geterrorhandler()(message)  end


-----------------------------
-- A function that does nothing. Maybe a bit more, it returns nil, so  tostring(LibCommon.DoNothing())  won't crash.
-- @return  nil  More than nothing..
--
LibCommon.ReturnNil = LibCommon.ReturnNil  or function()  return nil  end


