local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:  geterrorhandler
-- Used from LibCommon:
-- Exported to _G:
-- Exported to LibCommon:  istype,istable,isfunc,isstring,isnumber

-- Upvalued Lua globals:
local type = type


--[[ Copy-paste import code:
-- Typical:
local isstring,isnumber,istable = LibCommon:Import("isstring,isnumber,istable", MyAddon)
-- Advanced:
local istype,isstring,isnumber,istable,isfunc = LibCommon:Import("istype,isstring,isnumber,istable,isfunc", MyAddon)
--]]



-----------------------------
-- Type-check shorthands. Pick the ones you need.
-- As it returns the value it can be used to write compact checks, eg.:  textField:SetText( isstring(str) or "Wrong value" )
-- @param value  to check
-- @return value  if its type is as expected,  false otherwise.
--
if not LibCommon.istype then
	--- LibCommon. istype(value, typename):  @return true if type of `value` is `typeName`
	LibCommon.istype    = LibCommon.istype    or function(value, typename)   return  type(value)==typename   and value  end
	--- LibCommon. isfunc(value):        @return true if type of `value` is 'function'
	--- LibCommon. is<typename>(value):  @return true if type of `value` is <typeName>
	LibCommon.isstring  = LibCommon.isstring  or function(value)  return  type(value)=='string'   and value  end
	LibCommon.isnumber  = LibCommon.isnumber  or function(value)  return  type(value)=='number'   and value  end
	LibCommon.istable   = LibCommon.istable   or function(value)  return  type(value)=='table'    and value  end
	LibCommon.isfunc    = LibCommon.isfunc    or function(value)  return  type(value)=='function' and value  end
	-- thread == coroutine
	-- LibCommon.isthread = LibCommon.isthread or function(value)  return  type(value)=='thread'   and value  end
end



