-- Exported mock to LibCommon:  Import


--[[
-----------------------------
-- Mock implementation of  LibCommon:Import  that reports an error when used, then continues execution.
--- LibCommon:Import("<feature>[,<feature>]*", client or "clientname")
LibCommon.Import = LibCommon.Import or  function(FromLib, features, client, optional, stackdepth)
	-- Signal it's the mock implementation.
	if features == 'Import' then  return nil  end
	-- Importing only one feature (no list of features) that is present won't report an error as a convenience.
	local value = LibCommon[features]
	if value then  return value  end
	_G.geterrorhandler()(_G.tostring(client)..' requires "LibCommon.Import" loaded before.')
end
--]]



-- Check for mock implementation and drop it.
-- if LibCommon.Import and  not LibCommon:Import("Import", "LibCommon.Import", true)  then  LibCommon.Import = nil  end


