local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

G.assert(LibShared.softassert, 'Include "LibShared.softassert.lua" before.')

-- GLOBALS:
-- Used from _G:  ipairs
-- Used from LibShared:
-- Exported to _G:  inext
-- Exported to LibShared:  inext, nonext, ipairsOrNil,pairsOrNil

-- Upvalued Lua globals:
local type,error = type,error


-----------------------------
-- LibShared. inext() is the pair of next() that goes with ipairs()
LibShared.inext = LibShared.inext  or  G.ipairs({})
G.inext        = G.inext  or LibShared.inext
local inext = LibShared.inext


-----------------------------
LibShared.nonext = LibShared.nonext  or  function(t,i)  return nil,nil  end
local nonext = LibShared.nonext


-----------------------------
--- LibShared. pairsOrNil(t):   Iterate `t` if it's a table, like pairs(t), skip otherwise. Won't raise halting error.
-- Report (not raise) error if `t` is unexpected type (true/number/string/function/thread). Continue execution.
--
LibShared.pairsOrNil = LibShared.pairsOrNil  or  function(t)
  if type(t)=='table' then  return next ,t,nil
  elseif t then LibShared.softassert(false, "pairsOrNil(t) expected table or nil, got "..type(t))
	end
  return nonext,t,nil
end

-----------------------------
--- LibShared. ipairsOrNil(t):  Iterate `t` if it's a table, like ipairs(t), skip otherwise. Won't raise halting error.
-- Report (not raise) error if `t` is unexpected type (true/number/string/function/thread). Continue execution.
--
LibShared.ipairsOrNil = LibShared.ipairsOrNil  or  function(t)
  if type(t)=='table' then  return inext,t,0
	elseif t then LibShared.softassert(false, "ipairsOrNil(t) expected table or nil, got "..type(t))
	end
  return nonext,t,nil
end



--[[ One-liners.
local function nonext(t,i)     return nil,nil  end
LibShared.nonext      = LibShared.nonext       or  nonext
LibShared.pairsOrNil  = LibShared.pairsOrNil   or  function(t)  if type(t)=='table' then  return next ,t,nil  elseif t then LibShared.softassert(false, "pairsOrNil(t) expected table or nil, got "..type(t)) end  return nonext,t,nil  end
LibShared.ipairsOrNil = LibShared.ipairsOrNil  or  function(t)  if type(t)=='table' then  return inext,t,0   elseif t then LibShared.softassert(false, "ipairsOrNil(t) expected table or nil, got "..type(t)) end  return nonext,t,nil  end
--]]

--[[ Alternative:
local function  nextOrNil(t, last)  if not t then  return nil,nil  else  return  next(t, last)  end
local function inextOrNil(t, last)  if not t then  return nil,nil  else  return inext(t, last)  end
LibShared.pairsOrNil  = LibShared.pairsOrNil  or  function(t)  return  nextOrNil,t,nil  end
LibShared.ipairsOrNil = LibShared.ipairsOrNil or  function(t)  return inextOrNil,t,0    end
--]]


