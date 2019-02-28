local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  UnitName
-- Used from LibShared:
-- Exported to LibShared:  IsAddOnLoadable, IsAddOnEnabled

-- Upvalued Lua globals:
local GetAddOnInfo,GetAddOnEnableState = GetAddOnInfo,GetAddOnEnableState


-----------------------------
--- LibShared. IsAddOnLoadable(addonName):  Test if addon is loadable.
-- @param addonName - name of addon (name of addon folder and .toc file),  or the index in the addon list.
-- @return trueish  if loadable.  That is enabled, but not loaded?
--
LibShared.IsAddOnLoadable = LibShared.IsAddOnLoadable or  function(addonName)
	-- Note:  Until 5.4.8 (Mop) there was an extra `enabled` return before loadable.
	local name, title, notes, loadable, reason, security, newVersion = GetAddOnInfo(addonName)
	return loadable
end


-----------------------------
--- LibShared. IsAddOnEnabled(addonName):  Test if addon is enabled for current character.
-- @param addonName - name of addon (name of addon folder and .toc file),  or the index in the addon list.
-- @return trueish  if enabled.
--
LibShared.IsAddOnEnabled = LibShared.IsAddOnEnabled or  function(addonName)
	-- Patch 6.0.2 (Wod) added GetAddOnEnableState() == 0/1/2, 0 == disabled, 1 == enabled for some characters (when playerName == nil), 2 == enabled
	if GetAddOnEnableState then  return  0 ~= GetAddOnEnableState( _G.UnitName('player'), addonName )  end
	-- Until 5.4.8 (Mop) there was an extra `enabled` return before loadable.
	local name, title, notes, enabled, loadable, reason, security, newVersion = GetAddOnInfo(addonName)
	return enabled
end


