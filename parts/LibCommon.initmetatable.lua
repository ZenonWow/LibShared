local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Exported to LibCommon:  initmetatable, initmetatableDefaults, initmetatableOverwrite, initmetatableField
-- Used from LibCommon:
-- Used from _G:

-- Upvalued Lua globals:
local type,getmetatable,setmetatable = type,getmetatable,setmetatable


--[[ Copy-paste import code:
local initmetatable = LibCommon.Require.initmetatable
-- TODO: example
--]]



-----------------------------
--- LibCommon. initmetatable(obj):  Make sure obj has a metatable and return it.
-- @return metatable of obj, or nil if protected and hidden.
--
-- If obj has a protected and hidden metatable, it will return nil.
-- If the objects are from an unknown source then check for hidden metatable:
--  local meta = initmetatable(obj) ; if meta then  ..  end
-- If the objects are internal, shorthands can be used safely:
--  initmetatable(obj).__index = ..
-- To check what's in the hidden metatable's __metatable field call getmetatable(obj).
--  if not meta then  print("Protected metatable returned:  "..tostring( getmetatable(obj) ))  end
--
-- Rust: fn initmetatable(obj) -> getmetatable(obj)  ||  { let mt={} ; setmetatable(obj, mt) ; mt }
-- Non-Lua: local function initmetatable(obj)  return  getmetatable(obj) or ( setmetatable(obj, local mt={}) ; return mt )  end
-- Non-Lua: local function initmetatable(obj)  return  getmetatable(obj) else { let mt={} ; setmetatable(obj, mt) ; return mt }  end
--
LibCommon.initmetatable = LibCommon.initmetatable or function(obj, default)
	local meta = getmetatable(obj)
	if meta == nil then
		meta = default or {}
		setmetatable(obj, meta)
	elseif type(meta)~='table' then
		meta = nil
	end
	return meta
end

--[[ One long-liner.
LibCommon.initmetatable = LibCommon.initmetatable or function(obj, default)
	local meta = getmetatable(obj) ; if meta == nil then  meta = default or {} ; setmetatable(obj, meta)  elseif type(meta)~='table' then  meta = nil  end ; return meta
end
--]]



-----------------------------
--- LibCommon. initmetatableDefaults(obj, initFields):  Initialize fields in the metatable.
-- @param initFields (table) - fields to initialize. Won't overwrite values.
-- @return metatable of obj, or nil if protected and hidden.
-- 
-- Safely initialize the metatable (merges new fields into the metatable, does nothing if protected and hidden):
--  initmetatableDefaults(obj, { __index = .. , __newindex = .. })
--
LibCommon.initmetatableDefaults = LibCommon.initmetatableDefaults or function(obj, initFields)
	local meta = LibCommon.initmetatable(obj, initFields)
	if meta and meta~=initFields then
		for k,v in pairs(initFields) do  meta[k] = meta[k] or v  end
	end
	return meta
end



-----------------------------
--- LibCommon. initmetatableOverwrite(obj, setFields):  Overwrite fields in the metatable.
-- @param setFields (table) - fields to set.
-- @return metatable of obj, or nil if protected and hidden.
--
-- Safely update the metatable (merges the fields into the metatable, does nothing if protected and hidden):
--  initmetatableOverwrite(obj, { __index = .. , __newindex = .. })
--
LibCommon.initmetatableOverwrite = LibCommon.initmetatableOverwrite or function(obj, setFields)
	local meta = LibCommon.initmetatable(obj, setFields)
	if meta and meta~=setFields then
		for k,v in pairs(setFields) do  meta[k] = v  end
	end
	return meta
end



-----------------------------
--- LibCommon. initmetatableField(obj, fieldName, initValue):  Initialize obj's metatable and initialize (set if nil) field to initValue.
-- @param fieldName (string)  name of field to initialize.
-- @param initValue  default value of field.
-- @return metatable of obj.
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
LibCommon.initmetatableField = LibCommon.initmetatableField or function(obj, fieldName, initValue)
	local meta = LibCommon.initmetatable(obj)
	if  meta  and  meta[fieldName] == nil  then  meta[fieldName] = initValue  end
	return meta
end


