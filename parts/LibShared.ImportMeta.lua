local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  geterrorhandler
-- Used from LibShared:  _Missing
-- Exported to LibShared:  ImportMeta  (LibShared.Import.lua)


-----------------------------
--- LibShared:ImportMeta(fromTable, client or "clientname").<feature>.<feature>.<feature>...
--
LibShared.ImportMeta = LibShared.ImportMeta or  setmetatable({}, {
	__call = function(ImportMeta, FromLib, fromTable, client)
		return setmetatable({ _fromTable = fromTable, _client = client, _FromLib = FromLib, _Missing = FromLib._Missing or LibShared._Missing }, getmetatable(ImportMeta) )
		-- wipe(ImportMeta)  ;  ImportMeta._fromTable, ImportMeta._client, ImportMeta._FromLib, ImportMeta._Missing  =  fromTable, client, FromLib, FromLib._Missing or LibShared._Missing  ;  return ImportMeta
	end,
	__index = function(ImportMeta, feature)
		local impl = ImportMeta._FromLib[feature]
		if not impl then  ImportMeta._Missing(ImportMeta._FromLib, feature, ImportMeta._client, 2)  end
		ImportMeta._fromTable[feature] = impl
		return ImportMeta
	end,
	__newindex = function(ImportMeta, feature, newvalue)  _G.geterrorhandler()(false, "Do not modify LibShared.ImportMeta.".._G.tostring(feature))  end,
	end,
})


