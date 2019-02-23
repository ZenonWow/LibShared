local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

local LIBSHARED_REVISION = 1
-- Check if full library with same or higher revision is already loaded.
if (LibShared.revision or 0) >= LIBSHARED_REVISION then  return  end

LibShared.name = LibShared.name or LIBSHARED_NAME

-- GLOBALS:
-- Used from _G:  geterrorhandler, tostring
-- Used from LibShared:
-- Exported to LibShared:  Init

-- Localized Lua globals:  (used only in "main chunk", not in functions, therefore not upvalued)
local setmetatable = setmetatable

-- Upvalued Lua globals:
-- local rawset = rawset


--[[ Copy-paste usage:
-- Shared function loaded from first definition:
LibShared.Init.MyFeature = function()  ..  end
--]]



-----------------------------
--- LibShared.Init.<feature> = <Feature>
-- Initializes LibShared.<feature> if it's undefined.
--
-- For longer initialization check if feature is missing:
--  if not LibShared.<feature> then  ..  end
-- For one-liners:
--  LibShared.Init.<feature> = not LibShared.<feature>  and  ..
--
if  not LibShared.Init  or  LibShared.Init == LibShared  then

	LibShared.Init = LibShared.Init  or setmetatable({ _inTable = LibShared }, {
		__index = function(Init, feature)  _G.geterrorhandler()("Usage:  LibShared.Init.".._G.tostring(feature).." = .." )  end,
		__newindex = function(Init, feature, firstvalue)
			if Init._inTable[feature] then  return  end
			Init._inTable[feature] = firstvalue
			-- rawset(Init._inTable, feature, firstvalue)
		end,
	})

end


