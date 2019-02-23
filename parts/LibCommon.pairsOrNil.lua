local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:  ipairs
-- Used from LibCommon:
-- Exported to _G:  inext
-- Exported to LibCommon:  inext, nonext, ipairsOrNil,pairsOrNil

-- Upvalued Lua globals:
local type,error = type,error


-----------------------------
-- LibCommon. inext() is the pair of next() that goes with ipairs()
LibCommon.inext = LibCommon.inext  or  _G.ipairs({})
_G.inext        = _G.inext  or LibCommon.inext
local inext = LibCommon.inext


-----------------------------
LibCommon.nonext = LibCommon.nonext  or  function(t,i)  return nil,nil  end
local nonext = LibCommon.nonext


-----------------------------
--- LibCommon. pairsOrNil(t):   Iterate `t` if it's a table, like pairs(t), skip otherwise. Won't raise halting error.
-- Report (not raise) error if `t` is unexpected type (true/number/string/function/thread). Continue execution.
--
LibCommon.pairsOrNil = LibCommon.pairsOrNil  or  function(t)
  if type(t)=='table' then  return next ,t,nil
  elseif t then _G.geterrorhandler()("pairsOrNil(t) expected table or nil, got "..type(t))
	end
  return nonext,t,nil
end

-----------------------------
--- LibCommon. ipairsOrNil(t):  Iterate `t` if it's a table, like ipairs(t), skip otherwise. Won't raise halting error.
-- Report (not raise) error if `t` is unexpected type (true/number/string/function/thread). Continue execution.
--
LibCommon.ipairsOrNil = LibCommon.ipairsOrNil  or  function(t)
  if type(t)=='table' then  return inext,t,0
	elseif t then _G.geterrorhandler()("ipairsOrNil(t) expected table or nil, got "..type(t))
	end
  return nonext,t,nil
end



--[[ One-liners.
local function nonext(t,i)     return nil,nil  end
LibCommon.nonext      = LibCommon.nonext       or  nonext
LibCommon.pairsOrNil  = LibCommon.pairsOrNil   or  function(t)  if type(t)=='table' then  return next ,t,nil  elseif t then _G.geterrorhandler()("pairsOrNil(t) expected table or nil, got "..type(t)) end  return nonext,t,nil  end
LibCommon.ipairsOrNil = LibCommon.ipairsOrNil  or  function(t)  if type(t)=='table' then  return inext,t,0   elseif t then _G.geterrorhandler()("ipairsOrNil(t) expected table or nil, got "..type(t)) end  return nonext,t,nil  end
--]]

--[[ Alternative:
local function  nextOrNil(t, last)  if not t then  return nil,nil  else  return  next(t, last)  end
local function inextOrNil(t, last)  if not t then  return nil,nil  else  return inext(t, last)  end
LibCommon.pairsOrNil  = LibCommon.pairsOrNil  or  function(t)  return  nextOrNil,t,nil  end
LibCommon.ipairsOrNil = LibCommon.ipairsOrNil or  function(t)  return inextOrNil,t,0    end
--]]


