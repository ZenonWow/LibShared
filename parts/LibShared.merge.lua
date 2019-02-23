local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:
-- Used from LibShared:
-- Exported to LibShared:  merge

-- Upvalued Lua globals:
local next = next


--[[ Copy-paste import code:
local merge = LibShared.Require.merge
merge(tbl, { field1 = value1, field2 = value2, .. })
-- TODO: example
--]]



-----------------------------
-- More commonly known this is the table merge function:
--- LibShared. merge(first, { field1 = value1, field2 = value2, .. } )
-- Merges the second parameter into the first. That is, sets the fields specified in 2nd parameter.
-- @return first or second  If first table is nil, it returns the second, which can be nil as well.
--
LibShared.merge = LibShared.merge or function(first, second)
	-- Merge the second table into first. Check if the 2 tables are the same.
	if  not first  then  return second  end
	if  not second  or  first == second  then  return first  end
	-- for k,v in LibShared.pairsOrNil(second) do  first[k] = v  end
	for k,v in  next,second,nil  do  first[k] = v  end
	return first
end



-----------------------------
-- Merges the second table into the first, using a peculiar currying syntax common in functional programming:
--- LibShared. mergeCurry(first) { field1 = value1, field2 = value2, .. }
--
LibShared.mergeCurry = LibShared.mergeCurry or function(first)
	-- Functional style:  partially apply first.
	return  function(second) return LibShared.merge(first, second) end  end
end


