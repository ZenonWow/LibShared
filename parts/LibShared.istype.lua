local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  geterrorhandler
-- Used from LibShared:
-- Exported to _G:
-- Exported to LibShared:  istype,istable,isfunc,isstring,isnumber

-- Upvalued Lua globals:
local type = type


--[[ Copy-paste import code:
-- Typical:
local isstring,isnumber,istable = LibShared:Import("isstring,isnumber,istable", MyAddon)
-- Advanced:
local istype,isstring,isnumber,istable,isfunc = LibShared:Import("istype,isstring,isnumber,istable,isfunc", MyAddon)
--]]



-----------------------------
-- Type-check shorthands.  @return value  if its type is as expected,  false otherwise.
-- @param value  to check
-- As it returns the value it can be used to write compact checks, eg.:  textField:SetText( isstring(str) or "Wrong value" )
--
if not LibShared.istype then

	--- LibShared. istype(value, typename):  @return value if type of value is `typeName`
	LibShared.istype     = LibShared.istype     or function(value, typename)   return  type(value)==typename   and value  end
	LibShared.ifnil      = LibShared.ifnil      or function(value, default)    if value==nil then return default else return value end  end  -- retains false
	LibShared.ifelse     = LibShared.ifelse     or function(check, go, nogo)   if check then return go else return nogo end  end
  -- Conditional (ternary) operator missing from Lua.  Try:  check and false or nil  === nil always, only if can handle it, but if is a statement, and takes up a lot more space.
  -- ifelse(check, false, nil)  ==  check ? false : null (C++)  ==  check then false else nil (Ceylon-lang)  ==  if (check) false else null (Kotlin-lang)  ==  if check { false } else { None } (Rust-lang)
	-- LibShared.iffalse    = LibShared.iffalse    or function(value, default)    if value==false then return default else return value end  end  -- never used
	--- LibShared. isfunc(value):        @return value if value is a function
	--- LibShared. isthread(value):      @return value if value is a coroutine
	--- LibShared. isbool(value):        @return value if type of value is 'boolean'
	--- LibShared. is<typename>(value):  @return value if type of value is <typeName>
	LibShared.isstring   = LibShared.isstring   or function(value)  return  type(value)=='string'   and value  end
	LibShared.isnumber   = LibShared.isnumber   or function(value)  return  type(value)=='number'   and value  end
	LibShared.isbool     = LibShared.isbool     or function(value)  return  type(value)=='boolean'  and value  end
	LibShared.istable    = LibShared.istable    or function(value)  return  type(value)=='table'    and value  end
	LibShared.isuserdata = LibShared.isuserdata or function(value)  return  type(value)=='userdata' and value  end
	LibShared.isfunc     = LibShared.isfunc     or function(value)  return  type(value)=='function' and value  end
	LibShared.isthread   = LibShared.isthread   or function(value)  return  type(value)=='thread'   and value  end
	-- LibShared.isnil      = LibShared.isnil      or function(value)  return  type(value)=='nil'                 end  -- nil is also a type, but isnil is pointless

	LibShared.istablelike = LibShared.istablelike or function(value)  local t=type(value)  ;  return t=='table' or t=='userdata'  end


	-----------------------------
	--- LibShared.istype2(value, t1, t2):  Test if value is one of 2 types.
	-- @param value - any value to test
	-- @param t1..t2 - names of accepted types
	-- @return value if its type is accepted,  otherwise nil
	--
	LibShared.istype2 = LibShared.istype2 or  function(value, t1, t2)
		local t=type(value)  ;  if t==t1 or t==t2 then return value or true end  ;  return nil
	end


	-----------------------------
	--- LibShared.istype3(value, t1, t2, t3):  Test if value is one of 3 types.
	-- @param value - any value to test
	-- @param t1..t3 - names of accepted types
	-- @return value if its type is accepted,  otherwise nil
	--
	LibShared.istype3 = LibShared.istype3 or  function(value, t1, t2, t3)
		local t=type(value)  ;  if t==t1 or t==t2 or t==t3 then return value or true end  ;  return nil
	end

end


