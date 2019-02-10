local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

local LIBCOMMON_REVISION = 1
-- Check if full library with same or higher revision is already loaded.
if (LibCommon.revision or 0) >= LIBCOMMON_REVISION then  return  end

LibCommon.name = LibCommon.name or LIBCOMMON_NAME

-- GLOBALS:
-- Used from _G:  geterrorhandler, tostring, type
-- Used from LibCommon:
-- Exported to LibCommon:  Define, Has, Revisions, [softassert]
-- Exported mock to LibCommon:  Import

-- Localized Lua globals:  (used only in "main chunk", not in functions, therefore not upvalued)
local getmetatable,setmetatable = getmetatable,setmetatable

-- Upvalued Lua globals:
-- local rawget,rawset = rawget,rawset


--[[ Copy-paste usage:
-- Shared function loaded from first definition:
LibCommon.Define.MyFeature = function()  ..  end
-- Shared table created at first definition:
local MyFeatureTable = LibCommon.DefineTable.MyFeatureTable
MyFeatureTable.<field> = MyFeatureTable.<field> or ..
--]]



-- softassert(condition, message):  Report error without halting.
LibCommon.softassert = LibCommon.softassert or  function(ok, message)  return ok, ok or _G.geterrorhandler()(message)  end


-----------------------------
-- LibCommon.Revisions.<feature> == defined version of LibCommon.<feature>  or 0 if present, but no version defined  or -1 if not present.
--
LibCommon.Revisions = LibCommon.Revisions  or setmetatable({ _namespace = LibCommon }, {
	__newindex = function(Revisions, feature, newvalue)  LibCommon.softassert(false, "To define a versioned feature use:  LibCommon.Upgrade.".._G.tostring(feature).."[newversion] = ..")  end,
	__index    = function(Revisions, feature)  return  Revisions._namespace[feature]  and  0  or  -1  end,
	-- __index    = function(Revisions, feature)  return  rawget(Revisions._namespace, feature)  and  0  or  -1  end,
})


-----------------------------
--- LibCommon.Define.<feature> = <Feature>
--
-- To check if a feature is missing, use:
--  if not LibCommon.Has.<feature> then  ..  end
-- Or
--  LibCommon.Define.<feature> = not LibCommon.Has.<feature>  and  ..
-- Shorter for libraries:
--  LibCommon.Define.<feature> = not LibCommon.<feature>  and  ..
-- @return  true if LibCommon.<feature> is missing,  false if present.
--
if  not LibCommon.Define  or  LibCommon.Define == LibCommon  then

	LibCommon.Define = LibCommon.Define  or setmetatable({ _namespace = LibCommon }, {
		__index = function(Define, feature)
			local newroot = Define._namespace[feature]
			-- Traversing to a table (namespace) is ok. Otherwise it's probably a typo.
			LibCommon.softassert(_G.type(newroot)=='table', "Usage:  LibCommon.Define.<feature> = ..")
			return setmetatable({ _namespace = newroot }, getmetatable(Define))
		end,
		__newindex = function(Define, feature, newimpl)
			if Define._namespace[feature] then  return  end
			Define._namespace[feature] = newimpl
			-- rawset(Define._namespace, feature, newimpl)
		end,
	})

	-- for  Define.LibCommon.<feature> = ..
	LibCommon.LibCommon = LibCommon

end



-----------------------------
LibCommon.DefineTable = LibCommon.DefineTable  or setmetatable({ _namespace = LibCommon }, {
	__newindex = function(DefineTable, feature, newvalue)  LibCommon.softassert(false, "Usage:  local <Feature> = LibCommon.DefineTable.".._G.tostring(feature) )  end,
	__index    = function(DefineTable, feature)
		local value = DefineTable._namespace[feature]
		if not value then  value = {}  ;  DefineTable._namespace[feature] = value  end
		-- if not value then  value = {}  ;  rawset(DefineTable._namespace, feature, value)  end
		return value
	end,
})


