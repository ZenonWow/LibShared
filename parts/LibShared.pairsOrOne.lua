local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  ipairs, table, geterrorhandler
-- Used from LibShared:
-- Exported to _G:  inext
-- Exported to LibShared:  inext, tkeys, tvalues,  pairsOrOne, ipairsOrOne,  packOrOne

-- Upvalued Lua globals:
local type,select,next = type,select,next


--[[ Copy-paste import code:
-- Iterate table, survive if nil:
local pairsOrNil,ipairsOrNil = LibShared:Import("pairsOrNil,ipairsOrNil", MyAddon)
-- Store single element instead of table:
local pairsOrOne,ipairsOrOne,packOrOne = LibShared:Import("pairsOrOne,ipairsOrOne,packOrOne", MyAddon)
-- For who knows:
local inext = LibShared.Require.inext
--]]



-----------------------------
-- LibShared. inext() is the pair of next() that goes with ipairs()
LibShared.inext = LibShared.inext  or  G.ipairs({})
G.inext        = G.inext  or LibShared.inext
local inext = LibShared.inext


-----------------------------
LibShared.tkeys   = LibShared.tkeys   or  function(t)	 local ks={} ; for k,_ in next,t,nil do  ks[#ks+1] = k  end ; return ks  end
LibShared.tvalues = LibShared.tvalues or  function(t)  local vs={} ; for _,v in next,t,nil do  vs[#vs+1] = v  end ; return vs  end
G.table.keys = tkeys
G.table.values  = tvalues


-----------------------------
local function oneItemIterator(t,i)  if i==nil and t~=nil then  return 1,t  end end
local function oneKeyIterator (t,i)  if i==nil and t~=nil then  return t,t  end end


-----------------------------
-- Iterate over a table or just one element. One-element tables can be replaced by the element, that will act as an  element->element  mapping.
--- LibShared.pairsOrOne(t):   iterate the map   `t` like  pairs(t), additionally if `t` is not a table then iterate over the one-element map    { [t]=t }
--
LibShared.pairsOrOne = LibShared.pairsOrOne  or  function(t)
	if type(t)=='table'
	then  return next,t,nil
  else  return oneKeyIterator,t,nil
  end
end

-----------------------------
-- Iterate over a table or just one element. One-element tables can be replaced by the element, that will act as an  element->defValue  mapping.
--
LibShared.pairsOrOneDef = LibShared.pairsOrOneDef  or  function(t,def)
  if type(t)=='table'
	then  return next,t,nil
	else  return  (function(t,i) if i==nil and t~=nil then  return t,def  end end)  ,t,nil
	end
end

-----------------------------
-- Iterate over an array or just one element. One-element array can be replaced by the element, that will act as the first item:  { element }.
--- LibShared.ipairsOrOne(t):  iterate the array `t` like ipairs(t), additionally if `t` is not a table then iterate over the one-element array  { t }
--
LibShared.ipairsOrOne = LibShared.ipairsOrOne or  function(t)
  if type(t)=='table'
	then  return inext,t,0
	else  return oneItemIterator,t,nil
  end
end

--[[ One-liners.
LibShared.pairsOrOne  = LibShared.pairsOrOne  or  function(t)  if type(t)=='table' then  return next ,t,nil  else  return oneKeyIterator ,t,nil  end end
LibShared.ipairsOrOne = LibShared.ipairsOrOne or  function(t)  if type(t)=='table' then  return inext,t,0    else  return oneItemIterator,t,nil  end end
--]]


-----------------------------
-- Pack parameters into an array for ipairsOrOne().
-- With one parameter returns the solo element instead of a one-element array.
LibShared.packOrOne   = LibShared.packOrOne   or  function(...)
  local n=select('#',...)
  return  1<n  and  { n=n, ... }  or  ...
end



