local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

assert(LibShared.Define, 'Include "LibShared.Define.lua" before.')

-- GLOBALS:
-- Used from _G:
-- Used from LibShared:
-- Exported to LibShared:  CreateMacroButton
-- Upvalued Lua globals:


--[[ Copy-paste usage:
LibShared.Require.CreateMacroButton('ClearTargetButton', '/cleartarget', "Clear target")
--]]



--- CreateMacroButton(name, macrotext, label)
-- @return a Button that runs macrotext when clicked. Useable to create bindings that run a macro.
-- @param name  Identifier of binding.
-- @param macrotext  Macro code to execute when clicked.
-- @param label  The text visible on the builtin keybinding panel.
--
-- Suggested usage (replace the macrotext and the label "Clear target"):
-- LibShared.Require.CreateMacroButton('ClearTargetButton', '/cleartarget', "Clear target")
-- Then create a command binding with it in Bindings.xml (replace "ClearTargetButton"):
-- <Binding name="CLICK ClearTargetButton:LeftButton"></Binding>
--
LibShared.Define.CreateMacroButton = function(name, macrotext, label)
	local button = CreateFrame('Button', name, UIParent, 'SecureActionButtonTemplate')
	button:Hide()
	button:SetAttribute('type', 'macro')
	button:SetAttribute('macrotext', macrotext)
	button.binding = 'CLICK '..name..':LeftButton'
	if label then  _G['BINDING_NAME_'..button.binding] = label  end
	return button
end


