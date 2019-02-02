local _G, LibCommon = _G, LibCommon or {}
_G.LibCommon = LibCommon

-- Upvalued Lua globals
local type = type



-----------------------------
-- To use LibCommon.softassertf( condition, messageFormat, formatParameter* ):  include  `LibCommon.softassertf.lua`

--- LibCommon.softassert(condition, message)
-- @param message - error message passed to  errorhandler()  if condition fails.
-- Continue execution even if condition fails, unlike  assert().
-- @return condition, (message if condition fails)
LibCommon.softassert = LibCommon.softassert  or function(ok, message)
	return  ok,  not ok  and  (_G.geterrorhandler()(message) or message)  or  nil
end




-----------------------------
if not LibCommon.istype then
	--- LibCommon.istype(value, typename):  @return true if type of `value` is `typeName`
	LibCommon.istype   = LibCommon.istype    or function(value, typename)   return  type(value)==typename   and value  end
	---  LibCommon.is<typename>(value):  @return true if type of `value` is <typeName>
	-- except: LibCommon.isfunc(value):  @return true if type of `value` is 'function'
	LibCommon.istable  = LibCommon.istable   or function(value)  return  type(value)=='table'    and value  end
	LibCommon.isfunc   = LibCommon.isfunc    or function(value)  return  type(value)=='function' and value  end
	LibCommon.isstring = LibCommon.isstring  or function(value)  return  type(value)=='string'   and value  end
	LibCommon.isnumber = LibCommon.isnumber  or function(value)  return  type(value)=='number'   and value  end
end



-----------------------------
-- inext() is the pair of next() that goes with ipairs()
LibCommon.inext = LibCommon.inext  or _G.ipairs({})
_G.inext        = _G.inext  or LibCommon.inext



-----------------------------
local function nonext(t,i)     return nil,nil  end
-- LibCommon.nonext = LibCommon.nonext or nonext

-----------------------------
--- LibCommon.ipairsOrNil(t):  like ipairs(t), without raising error in any case.
--- LibCommon.pairsOrNil(t):   like  pairs(t), without raising error in any case.
-- Iterate `t` if it's a table, skip otherwise.
-- Report (not raise) error if `t` is unexpected type (true/number/string/function/thread).
-- Continue execution even if reporting error.
LibCommon.ipairsOrNil = LibCommon.ipairsOrNil  or function(t)  if type(t)=='table' then  return inext,t,0    else  if not t then  return nonext,t,nil  else  error("ipairsOrNil(t) expected table or nil, got "..type(t))  end end end
LibCommon.pairsOrNil  = LibCommon.pairsOrNil   or function(t)  if type(t)=='table' then  return next ,t,nil  else  if not t then  return nonext,t,nil  else  error( "pairsOrNil(t) expected table or nil, got "..type(t))  end end end



-----------------------------
-- Mock implementation of  LibCommon.UpgradeCheck  that reports an error when used, then continues execution.
--
if not LibCommon.UpgradeCheck then
	local function err(UpgradeCheck, feature, newversion)  _G.geterrorhandler()("Versioning requires LibCommon.UpgradeCheck. Implementation of LibCommon."..feature.." ignored.")  end
	-- Facilitate self-upgrade:  LibCommon.UpgradeCheck.UpgradeCheck(anyversion)  returns 0,  asking for an upgrade.
	LibCommon.UpgradeCheck = _G.setmetatable({ UpgradeCheck = function()  return 0  end }, { __newindex = err, __index = err, __call = err })
end



