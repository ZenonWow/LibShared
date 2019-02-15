local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

local LIBCOMMON_REVISION = 1
-- Check if full library with same or higher revision is already loaded.
if (LibCommon.revision or 0) >= LIBCOMMON_REVISION then  return  end

LibCommon.name = LibCommon.name or LIBCOMMON_NAME

-- GLOBALS:
-- Used from _G:  geterrorhandler, tostring
-- Used from LibCommon:
-- Exported to LibCommon:  Init

-- Localized Lua globals:  (used only in "main chunk", not in functions, therefore not upvalued)
local setmetatable = setmetatable

-- Upvalued Lua globals:
-- local rawset = rawset


--[[ Copy-paste usage:
-- Shared function loaded from first definition:
LibCommon.Init.MyFeature = function()  ..  end
--]]



-----------------------------
--- LibCommon.Init.<feature> = <Feature>
-- Initializes LibCommon.<feature> if it's undefined.
--
-- For longer initialization check if feature is missing:
--  if not LibCommon.<feature> then  ..  end
-- For one-liners:
--  LibCommon.Init.<feature> = not LibCommon.<feature>  and  ..
--
if  not LibCommon.Init  or  LibCommon.Init == LibCommon  then

	LibCommon.Init = LibCommon.Init  or setmetatable({ _inTable = LibCommon }, {
		__index = function(Init, feature)  _G.geterrorhandler()("Usage:  LibCommon.Init.".._G.tostring(feature).." = .." )  end,
		__newindex = function(Init, feature, firstvalue)
			if Init._inTable[feature] then  return  end
			Init._inTable[feature] = firstvalue
			-- rawset(Init._inTable, feature, firstvalue)
		end,
	})

end


