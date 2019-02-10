local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:  ipairs
-- Used from LibCommon:
-- Exported to _G:  inext
-- Exported to LibCommon:  inext, ipairsOrNil,pairsOrNil

-- Upvalued Lua globals:
local type,error = type,error


-----------------------------
-- LibCommon. inext() is the pair of next() that goes with ipairs()
LibCommon.inext = LibCommon.inext or  _G.ipairs({})
_G.inext        = _G.inext  or LibCommon.inext
local inext = LibCommon.inext


-----------------------------
--- LibCommon. pairsOrNil(t):   like  pairs(t), without raising error in any case.
--- LibCommon. ipairsOrNil(t):  like ipairs(t), without raising error in any case.
-- Iterate `t` if it's a table, skip otherwise.
-- Report (not raise) error if `t` is unexpected type (true/number/string/function/thread).
-- Continue execution even if reporting error.
local function nonext(t,i)     return nil,nil  end
LibCommon.pairsOrNil  = LibCommon.pairsOrNil  or  function(t)  if type(t)=='table' then  return next ,t,nil  else  if not t then  return nonext,t,nil  else  error( "pairsOrNil(t) expected table or nil, got "..type(t))  end end end
LibCommon.ipairsOrNil = LibCommon.ipairsOrNil or  function(t)  if type(t)=='table' then  return inext,t,0    else  if not t then  return nonext,t,nil  else  error("ipairsOrNil(t) expected table or nil, got "..type(t))  end end end

--[[ Alternative:
local function  nextOrNil(t, last)  if not t then  return nil,nil  else  return  next(t, last)  end
local function inextOrNil(t, last)  if not t then  return nil,nil  else  return inext(t, last)  end
LibCommon.pairsOrNil  = LibCommon.pairsOrNil  or  function(t)  return  nextOrNil,t,nil  end
LibCommon.ipairsOrNil = LibCommon.ipairsOrNil or  function(t)  return inextOrNil,t,0    end
--]]


