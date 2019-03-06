local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

G.assert(LibShared.softassert, 'Include "LibShared.softassert.lua" before.')

-- GLOBALS:
-- Used from _G:  geterrorhandler, tostring
-- Used from LibShared:
-- Exported to LibShared:  OptFunc

-- Localized Lua globals:  (used only in "main chunk", not in functions, therefore not upvalued)
local setmetatable = setmetatable

-- Upvalued Lua globals:
local type = type


--[[ Copy-paste import code:
-- Cache in local variable:
local Feature = LibShared.OptFunc.<feature>
Feature(..)
-- Use in-situ:
LibShared.Require.<feature>(..)
--]]


-----------------------------
--- LibShared.OptFunc.<feature>(..)
-- Call a feature function. If the function is not defined, then instead of crashing call the empty  LibShared.ReturnNil()  function.
--- local result = LibShared.OptFunc.<feature>(..)
--
LibShared.OptFunc = LibShared.OptFunc  or setmetatable({ _inTable = LibShared }, {
	__newindex = function(OptFunc, feature, newvalue)  G.geterrorhandler()("Usage:  local result = LibShared.OptFunc."..G.tostring(feature).."(..)" )  end,
	__index    = function(OptFunc, feature)
		local value = OptFunc._inTable[feature]
		if type(value)~='function' then
			LibShared.softassert( type == nil, "Warn: LibShared.OptFunc."..tostring(feature)..":  expected function, found "..type(value) )
			value = LibShared.ReturnNil
		end
		return value
	end,
})



-----------------------------
-- A function that does nothing. Maybe a bit more, it returns nil, so  tostring(LibShared.DoNothing())  won't crash.
-- @return  nil  More than nothing..
--
LibShared.ReturnNil = LibShared.ReturnNil  or function()  return nil  end


