local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

if not LibShared.isstring and G.DEVMODE then  G.geterrorhandler()('Include "LibShared.istype.lua" before.')  end


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
-- @param callDepth  only libraries need it, @see 2nd parameter of  error()
-- @return LibShared.<feature>(s)  if loaded.
-- @throw if missing and not optional:  an error including client name or caller's filename.
--
-- Using LibShared.Revisions to identify mock implementation.
-- LibShared.Require.Revisions.Import == 0  then  LibShared.Import = nil  end
-- rawset(LibShared.Revisions, 'Import', 1)
--
-- Using LibShared.Upgrade to override mock implementation.
-- local IMPORT_REVISION = 1
-- LibShared.Require.Upgrade.Import[IMPORT_REVISION] = function(from, features, client, optional, callDepth)
--
LibShared.Import = LibShared.Import or  function(from, features, client, optional, callDepth)
	LibShared.asserttype(from, 'table', "Usage: LibShared:Import(features, client): `LibShared` - ", (callDepth or 0)+1 )
	LibShared.asserttype(features, 'string', "Usage: LibShared:Import(features, client): `features` - ", (callDepth or 0)+1 )
	local names, list, missing = { strsplit(", ", features) }, { n = 0 }, nil
	for  i,feature  in ipairs(names) do  if feature ~= "" then
		list.n, value = list.n + 1, from[feature]
		list[list.n] = value
		if not value then  missing =  missing  and  missing..", ."..feature  or  feature  end
	end end  -- for if
	if missing and not optional then  LibShared._Missing(from, missing, client, (callDepth or 0)+1)  end
	return unpack(list, 1, list.n)
end


-----------------------------
--- LibShared:_Missing(("<feature>[, .<feature>]*", client/"clientname", [callDepth])
-- @param callDepth  how deep the trouble is...  @see 2nd parameter of  error()
-- @throw a "requires" error including client name or caller's filename.
--
LibShared._Missing = LibShared._Missing or  function(from, features, client, callDepth)
	local isstring = LibShared.isstring
	local clientname = isstring(client)
		or  type(client)=='table' and ( isstring(client.name)  or  type(client.GetName)=='function' and client:GetName() )
		or  "Executed code"
	-- local clientname = G.tostring( client or "Executed code" )
	error( clientname..' requires "'..(isstring(from.name) or 'LibShared')..'.'..features..'" to be loaded before.' , (callDepth or 0)+2 )  -- error() requires +2 callDepth (one for itself...)
end

-- Dependency from LibShared.istype.lua:
LibShared.isstring  = LibShared.isstring  or function(value)  return  type(value)=='string'   and value  end


