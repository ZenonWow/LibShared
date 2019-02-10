local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:
-- Used from LibCommon:  _Missing
-- Exported to LibCommon:  ImportMeta


-----------------------------
--- LibCommon:ImportMeta(namespace, client or "clientname").<feature>.<feature>.<feature>...
--
LibCommon.ImportMeta = LibCommon.ImportMeta or  setmetatable({}, {
	__call = function(ImportMeta, FromLib, namespace, client)
		return setmetatable({ _namespace = namespace, _client = client, _FromLib = FromLib, _Missing = FromLib._Missing or LibCommon._Missing }, getmetatable(ImportMeta) )
		-- wipe(ImportMeta)  ;  ImportMeta._namespace, ImportMeta._client, ImportMeta._FromLib, ImportMeta._Missing  =  namespace, client, FromLib, FromLib._Missing or LibCommon._Missing  ;  return ImportMeta
	end,
	__index = function(ImportMeta, feature)
		local impl = ImportMeta._FromLib[feature]
		if not impl then  ImportMeta._Missing(ImportMeta._FromLib, feature, ImportMeta._client, 2)  end
		ImportMeta._namespace[feature] = impl
		return ImportMeta
	end,
	__newindex = function(ImportMeta, feature, newvalue)  _G.geterrorhandler()("Do not modify LibCommon.ImportMeta.".._G.tostring(feature))  end,
	end,
})


