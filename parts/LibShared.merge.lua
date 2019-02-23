local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:
-- Used from LibCommon:
-- Exported to LibCommon:  merge

-- Upvalued Lua globals:
local next = next


--[[ Copy-paste import code:
local merge = LibCommon.Require.merge
merge(tbl, { field1 = value1, field2 = value2, .. })
-- TODO: example
--]]



-----------------------------
-- More commonly known this is the table merge function:
--- LibCommon. merge(first, { field1 = value1, field2 = value2, .. } )
-- Merges the second parameter into the first. That is, sets the fields specified in 2nd parameter.
-- @return first or second  If first table is nil, it returns the second, which can be nil as well.
--
LibCommon.merge = LibCommon.merge or function(first, second)
	-- Merge the second table into first. Check if the 2 tables are the same.
	if  not first  then  return second  end
	if  not second  or  first == second  then  return first  end
	-- for k,v in LibCommon.pairsOrNil(second) do  first[k] = v  end
	for k,v in  next,second,nil  do  first[k] = v  end
	return first
end



-----------------------------
-- Merges the second table into the first, using a peculiar currying syntax common in functional programming:
--- LibCommon. mergeCurry(first) { field1 = value1, field2 = value2, .. }
--
LibCommon.mergeCurry = LibCommon.mergeCurry or function(first)
	-- Functional style:  partially apply first.
	return  function(second) return LibCommon.merge(first, second) end  end
end


