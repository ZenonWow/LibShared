local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:
-- Used from LibShared:
-- Exported to LibShared:  SetScript.OnEvent
-- Upvalued Lua globals:


--[[ Copy-paste import code:
local ADDON_NAME, _ADDON = ...
local frame = CreateFrame('Frame')
LibShared.SetScript.OnEvent(frame)
frame:RegisterEvent('ADDON_LOADED')
function frame:ADDON_LOADED(eventName, addonName)
	if addonName ~= ADDON_NAME then  return  end
	-- SavedVariables loaded. Init settings.
end
--]]



--- LibShared.SetScript.OnEvent(frame):  Set a default 'OnEvent' script for the frame.
-- It dispatches events to methods on the frame with the same name as the event.
-- Like:  frame:ADDON_LOADED(eventName, addonName)  and  frame:PLAYER_LOGIN('PLAYER_LOGIN')  and so on.
--
LibShared.SetScript = LibShared.SetScript or {}
LibShared.SetScript.OnEvent = LibShared.SetScript.OnEvent  or  function(frame, eventName, ...)  if frame[eventName] then  frame[eventName](frame, eventName, ...)  end end


