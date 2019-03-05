-- Exported mock to LibShared:  Import


--[[
-----------------------------
-- Mock implementation of  LibShared:Import  that reports an error when used, then continues execution.
--- LibShared:Import("<feature>[,<feature>]*", client or "clientname")
LibShared.Import = LibShared.Import or  function(FromLib, features, client, optional, stackdepth)
	-- Signal it's the mock implementation.
	if features == 'Import' then  return nil  end
	-- Importing only one feature (no list of features) that is present won't report an error as a convenience.
	local value = LibShared[features]
	if value then  return value  end
	G.geterrorhandler()(G.tostring(client)..' requires "LibShared.Import" loaded before.')
end
--]]



-- Check for mock implementation and drop it.
-- if LibShared.Import and  not LibShared:Import("Import", "LibShared.Import", true)  then  LibShared.Import = nil  end


