local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:  geterrorhandler
-- Used from LibCommon:
-- Exported to LibCommon:  merge, initmetatable

-- Upvalued Lua globals:
local type,getmetatable,setmetatable = type,getmetatable,setmetatable


--[[ Copy-paste import code:
local merge = LibCommon.Require.merge
local initmetatable = LibCommon.Require.initmetatable
--]]



-----------------------------
-- Merges the second table into the first, using a peculiar currying syntax common in functional programming:
--- LibCommon. merge(obj) { field1 = value1, field2 = value2, .. }
-- More commonly known this is the table merge function:
--- LibCommon. merge(obj, { field1 = value1, field2 = value2, .. } )
-- Merges the second parameter into the first. That is, sets the fields specified in 2nd parameter.
-- @return obj or second  If first table is nil, it returns the second, which can be nil as well.
LibCommon.merge = LibCommon.merge or  function(obj, second)
	-- Functional style:  partially apply obj.
	if not second then  return  function(values) return LibCommon.merge(obj, values) end  end
	-- Merge the second table into first. Check if the 2 tables are the same.
	if  not obj  or  obj == second  then  return second  end
	-- for k,v in LibCommon.pairsOrNil(second) do  obj[k] = v  end
	for k,v in  (second and next or nonext),second,nil  do  obj[k] = v  end
	return obj
end



-----------------------------
--- LibCommon. initmetatable(obj, [setFields]):  Initialize obj's metatable and return it.
-- @param setFields (table)  optionally set the fields from setFields on the metatable.
-- @return metatable of obj, created if necessary.
--
-- If obj has a hidden/protected metatable, it will return a string or false or any other type.
-- If the objects are from an unknown source then check for protected metatable:
--  local meta = initmetatable(obj) ; if LibCommon.istable(meta) then  ..  end
-- Safely initialize the metatable (skips if protected):
--  initmetatable(obj, { __index = .. , __newindex = .. })
-- If the objects are internal, shorthands can be used safely:
--  initmetatable(obj).__index = ..
--
-- Rust: fn initmetatable(obj) -> getmetatable(obj)  ||  { let mt={} ; setmetatable(obj, mt) ; mt }
-- Non-Lua: local function initmetatable(obj)  return  getmetatable(obj) or ( setmetatable(obj, local mt={}) ; return mt )  end
-- Non-Lua: local function initmetatable(obj)  return  getmetatable(obj) else { let mt={} ; setmetatable(obj, mt) ; return mt }  end
--
LibCommon.initmetatable = LibCommon.initmetatable or  function(obj, setFields)
	local meta = getmetatable(obj)
	if type(meta)=='table' then
		LibCommon.merge(meta, setFields)
	elseif meta==nil then
		meta = setFields or {}
		setmetatable(obj, meta)
	end
	return meta
end

--[[ One-liner.
LibCommon.initmetatable = LibCommon.initmetatable or  function(obj, setFields)
	local meta = getmetatable(obj) ; if type(meta)=='table' then  LibCommon.merge(meta, setFields)  elseif meta==nil then  meta = setFields or {} ; setmetatable(obj, meta)  end  ;  return meta
end
--]]


