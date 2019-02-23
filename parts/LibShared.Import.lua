local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

if not LibShared.isstring and _G.DEVMODE then  _G.geterrorhandler()('Include "LibShared.istype.lua" before.')  end


-- GLOBALS:
-- Used from _G:  (tostring)
-- Used from LibShared:  isstring
-- Exported to LibShared:  Import, _Missing, isstring

-- Upvalued Lua globals:
local ipairs,unpack,strsplit,type = ipairs,unpack,string.split,type



-----------------------------
--- local <feature>,<feature>* = LibShared:Import("<feature>[,<feature>]*", client/"clientname", [optional])
-- Import more features in one line, eg.:
--  local softassert,istable,isstring,isnumber = LibShared:Import("softassert,istable,isstring,isnumber", MyAddon)
-- @param features - one string - comma/whitespace separated list of feature names
-- @param client - addon object or string - the .name field is printed in any error message.
-- @param optional - don't raise an error if some feature is missing, just return nil in its place.
-- Other features are still returned.
-- @param stackdepth  only libraries need it, @see 2nd parameter of  error()
-- @return LibShared.<feature>(s)  if loaded.
-- @throw if missing and not optional:  an error including client name or caller's filename.
--
-- Using LibShared.Revisions to identify mock implementation.
-- LibShared.Require.Revisions.Import == 0  then  LibShared.Import = nil  end
-- rawset(LibShared.Revisions, 'Import', 1)
--
-- Using LibShared.Upgrade to override mock implementation.
-- local IMPORT_REVISION = 1
-- LibShared.Require.Upgrade.Import[IMPORT_REVISION] = function(_fromTable, features, client, optional, stackdepth)
--
LibShared.Import = LibShared.Import or  function(_fromTable, features, client, optional, stackdepth)
	local names, list, missing = { strsplit(", ", features) }, { n = 0 }, nil
	for  i,feature  in ipairs(names) do  if feature ~= "" then
		list.n, value = list.n + 1, _fromTable[feature]
		list[list.n] = value
		if not value then  missing =  missing  and  missing..", ."..feature  or  feature  end
	end end  -- for if
	if missing and not optional then  LibShared._Missing(_fromTable, missing, client, (stackdepth or 1)+1)  end
	return unpack(list, 1, list.n)
end


-----------------------------
--- LibShared:_Missing(("<feature>[, .<feature>]*", client/"clientname", [stackdepth])
-- @param stackdepth  how deep the trouble is...  @see 2nd parameter of  error()
-- @throw a "requires" error including client name or caller's filename.
--
LibShared._Missing = LibShared._Missing or  function(_fromTable, features, client, stackdepth)
	local isstring = LibShared.isstring
	local clientname = isstring(client)
		or  type(client)=='table' and ( isstring(client.name)  or  type(client.GetName)=='function' and client:GetName() )
		or  "Executed code"
	-- local clientname = _G.tostring( client or "Executed code" )
	error( clientname..' requires "'..(isstring(_fromTable.name) or 'LibShared')..'.'..features..'" to be loaded before.' , (stackdepth or 1)+1 )
end

-- Dependency from LibShared.istype.lua:
LibShared.isstring  = LibShared.isstring  or function(value)  return  type(value)=='string'   and value  end


