local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

G.assert(LibShared.softassert and LibShared.assertnf, 'Include "LibShared.softassert.lua" before.')

-- GLOBALS:
-- Used from _G:  tostring, assert
-- Used from LibShared:  softassert
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
-- LibShared.Revisions:_Define('<feature>', value, revision):  Set stored revision of current implementation, used for functions and values.
-- LibShared.Revisions:_Upgrade('<feature>', value, revision):  Set/overwrite stored revision of table.
--
LibShared.Revisions = LibShared.Revisions  or setmetatable({ _namespace = LibShared,
	-- Weak-keyed map:  function/table -> revision (number).  Whenever a function is upgraded, the new revision is added to the map,
	-- and the old revision can be garbagecollected automatically, if it's not referenced by client code.
	_revisions = setmetatable({}, { __mode = 'k' }),
	_Define = function(Revisions, feature, value, revision)
		local wasRev = Revisions._revisions[value]
		LibShared.assertnf(1, nil==wasRev, "LibShared.Revisions:_Define('%s', value, %d): %s already defined as revision %d", feature, revision, type(value), wasRev)
		LibShared.assertnf(1, Revisions._namespace[feature] == value, "Usage: set  LibShared.%s = value  before  LibShared.Revisions:_Define('%s', value, %d)", feature, feature, revision)
		Revisions._revisions[value] = revision
	end,
	_Upgrade = function(Revisions, feature, value, revision)
		LibShared.assertnf(1, Revisions._namespace[feature] == value, "Usage: set  LibShared.%s = value  before  LibShared.Revisions:_Upgrade('%s', value, %d)", feature, feature, revision)
		LibShared.assertnf(1, LibShared.istablelike(value), "Use _Upgrade() for tables. For %s:  LibShared.Revisions:_Define('%s', value, %d)", type(value), feature, revision)
		Revisions._revisions[value] = revision
	end,
}, {
	__newindex = function(Revisions, feature, newvalue)  LibShared.softassert(false, "To define a versioned feature use:  LibShared.Upgrade."..G.tostring(feature).."[newversion] = ..")  end,
	__index    = function(Revisions, feature)
		local value = Revisions._namespace[feature]
		if value then  return Revisions._revisions[value] or 0  end
		return -1
	end,
})


