local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:  ipairs, geterrorhandler
-- Used from LibCommon:
-- Exported to _G:  inext
-- Exported to LibCommon:  inext, tkeys, tvalues,  pairsOrNil, ipairsOrNil,  pairsOrOne, ipairsOrOne,  packOrOne

-- Upvalued Lua globals:
local type,select = type,select
local next,inext = next, LibCommon.inext  or _G.ipairs({})


--[[ Copy-paste import code:
-- Iterate table, survive if nil:
local pairsOrNil,ipairsOrNil = LibCommon:Import("pairsOrNil,ipairsOrNil", MyAddon)
-- Store single element instead of table:
local pairsOrOne,ipairsOrOne,packOrOne = LibCommon:Import("pairsOrOne,ipairsOrOne,packOrOne", MyAddon)
-- For who knows:
local inext = LibCommon.Require.inext
--]]



-----------------------------
-- LibCommon. inext() is the pair of next() that goes with ipairs()
LibCommon.inext = LibCommon.inext or  _G.ipairs({})
_G.inext        = _G.inext  or LibCommon.inext
local inext = LibCommon.inext


-----------------------------
LibCommon.tkeys   = LibCommon.tkeys   or  function(t)	 local ks={} ; for k,_ in next,t,nil do  ks[#ks+1] = k  end ; return ks  end
LibCommon.tvalues = LibCommon.tvalues or  function(t)  local vs={} ; for _,v in next,t,nil do  vs[#vs+1] = v  end ; return vs  end
table.keys = tkeys
table.values  = tvalues


-----------------------------
local function oneItemIterator(t,i)  if i==nil and t~=nil then  return 1,t  end end
local function oneKeyIterator (t,i)  if i==nil and t~=nil then  return t,t  end end
local function nonext(t,i)     return nil,nil  end


-----------------------------
--- LibCommon.pairsOrNil(t):   like  pairs(t), without raising error if `t` is nil.
--- LibCommon.ipairsOrNil(t):  like ipairs(t), without raising error if `t` is nil.
-- Iterate `t` if it's a table, skip otherwise.
-- Report (not raise) error if `t` is unexpected type (true/number/string/function/thread).
-- Continue execution even if reporting error.
LibCommon.pairsOrNil  = LibCommon.pairsOrNil  or  function(t)  if type(t)=='table' then  return next ,t,nil  else  if not t then  return nonext,t,nil  else  _G.geterrorhandler()(  "pairsOrNil(t) expected table or nil, got "..type(t) )  end end end
LibCommon.ipairsOrNil = LibCommon.ipairsOrNil or  function(t)  if type(t)=='table' then  return inext,t,0    else  if not t then  return nonext,t,nil  else  _G.geterrorhandler()( "ipairsOrNil(t) expected table or nil, got "..type(t) )  end end end


-----------------------------
-- Iterate over a table or just one element. One-element tables can be replaced by the element.
--- LibCommon.pairsOrOne(t):   iterate the map   `t` like  pairs(t), additionally if `t` is not a table then iterate over the one-element map    { [t]=t }
--- LibCommon.ipairsOrOne(t):  iterate the array `t` like ipairs(t), additionally if `t` is not a table then iterate over the one-element array  { t }
LibCommon.pairsOrOne  = LibCommon.pairsOrOne  or  function(t)  if type(t)=='table' then  return next ,t,nil  else  return oneKeyIterator ,t,nil  end end
LibCommon.ipairsOrOne = LibCommon.ipairsOrOne or  function(t)  if type(t)=='table' then  return inext,t,0    else  return oneItemIterator,t,nil  end end


-----------------------------
-- Pack parameters into an array for ipairsOrOne().
-- With one parameter returns the solo element instead of a one-element array.
LibCommon.packOrOne   = LibCommon.packOrOne   or  function(...)  return  1 < select('#',...)  and  {...}  or  ...  end



