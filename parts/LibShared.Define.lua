local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

local LIBSHARED_REVISION = 10
-- Check if full library with same or higher revision is already loaded.
if (LibShared.revision or 0) >= LIBSHARED_REVISION then  return  end

LibShared.name = LibShared.name or LIBSHARED_NAME

-- GLOBALS:
-- Used from _G:  geterrorhandler, tostring
-- Used from LibShared:
-- Exported to LibShared:  Define

-- Localized Lua globals:  (used only in "main chunk", not in functions, therefore not upvalued)
local setmetatable = setmetatable

-- Upvalued Lua globals:
-- local rawset = rawset


--[[ Copy-paste usage:
-- Shared function loaded from first definition:
LibShared.Define.MyFeature = function()  ..  end
--]]



-----------------------------
--- LibShared.Define.<feature> = <Feature>
-- Initializes LibShared.<feature> if it's undefined.
--
-- For longer initialization check if feature is missing:
--  if not LibShared.<feature> then  ..  end
-- For one-liners:
--  LibShared.Define.<feature> = not LibShared.<feature>  and  ..
--
if  not LibShared.Define  or  LibShared.Define == LibShared  then

	LibShared.Define = LibShared.Define  or setmetatable({ _namespace = LibShared }, {
		__index = function(Define, feature)  _G.geterrorhandler()("Usage:  LibShared.Define.".._G.tostring(feature).." = .." )  end,
		__newindex = function(Define, feature, firstvalue)
			if Define._namespace[feature] then  return  end
			Define._namespace[feature] = firstvalue
			-- rawset(Define._namespace, feature, firstvalue)
		end,
	})

end


