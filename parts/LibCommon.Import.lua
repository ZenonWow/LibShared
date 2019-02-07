local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME]
assert(LibCommon and LibCommon.Require, 'Include "LibCommon.Require.lua" before.')
-- LibCommon.Require("Define,Upgrade,isstring")
LibCommon.Require.Define
LibCommon.Require.Upgrade
LibCommon.Require.isstring

-- GLOBALS:
-- Used from _G:
-- Used from LibCommon:  Require, Define, Upgrade  (only for init)
-- Used from LibCommon:  isstring
-- Exported to LibCommon:  Import, _Missing

-- Upvalued Lua globals:
local ipairs,unpack,strsplit,type = ipairs,unpack,string.split,type



-----------------------------
--- local <feature>,<feature>* = LibCommon:Import("<feature>[,<feature>]*", client/"clientname", [optional])
-- Import more features in one line, eg.:
--  local softassert,istable,isstring,isnumber = LibCommon:Import("softassert,istable,isstring,isnumber", MyAddon)
-- @param features - one string - comma/whitespace separated list of feature names
-- @param client - addon object or string - the .name field is printed in any error message.
-- @param optional - don't raise an error if some feature is missing, just return nil in its place.
-- Other features are still returned.
-- @param stackdepth  only libraries need it, @see 2nd parameter of  error()
-- @return LibCommon.<feature>(s)  if loaded.
-- @throw if missing and not optional:  an error including client name or caller's filename.
--
-- Check for mock implementation and drop it.
-- if LibCommon.Import and  not LibCommon:Import("Import", "LibCommon.Import", true)  then  LibCommon.Import = nil  end
--
-- LibCommon.Define.Import = function(_namespace, features, client, optional, stackdepth)
--
-- Using LibCommon.Upgrade to override mock implementation.
local IMPORT_REVISION = 1

LibCommon.Upgrade.Import[IMPORT_REVISION] = function(_namespace, features, client, optional, stackdepth)
	local list, impls, missing = strsplit(", ", features), { n = 0 }
	for  i,feature  in ipairs(list) do  if feature ~= "" then
		impls.n, impl = impls.n + 1, _namespace[feature]
		impls[impls.n] = impl
		if not impl then  missing =  missing  and  missing..", ."..feature  or  feature  end
	end end  -- for if
	if missing and not optional then  LibCommon._Missing(_namespace, missing, client, (stackdepth or 1)+1)  end
	return unpack(impls, 1, impls.n)
end


-----------------------------
--- LibCommon:_Missing(("<feature>[, .<feature>]*", client/"clientname", [stackdepth])
-- @param stackdepth  how deep the trouble is...  @see 2nd parameter of  error()
-- @throw a "requires" error including client name or caller's filename.
--
LibCommon.Define._Missing = function(_namespace, features, client, stackdepth)
	local isstring = LibCommon.isstring  or function(value)  return  type(value)=='string'   and value  end  -- Copied from LibCommon.istype.lua
	local clientname = isstring(client)  or  type(client)=='table' and isstring(client.name)  or  "Executed code"
	-- local clientname = _G.tostring( client or "Executed code" )
	error( clientname..' requires "'..(isstring(_namespace.name) or 'LibCommon')..'.'..features..'" to be loaded before.' , (stackdepth or 1)+1 )
end


