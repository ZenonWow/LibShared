local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME] or {}  ;  _G[LIBCOMMON_NAME] = LibCommon

-- GLOBALS:
-- Used from _G:  debugstack
-- Used from LibCommon:
-- Exported to LibCommon:  debugfilename, debugfileline
-- Upvalued Lua globals:


-----------------------------
LibCommon.debugfilename = LibCommon.debugfilename  or function(stackdepth)
	-- Allow hooking (replacing) _G.debugstack()
	return _G.debugstack( (stackdepth or 1)+1, 3, 0):match( "\\(.-)[:>]")
end


-----------------------------
LibCommon.debugfileline = LibCommon.debugfileline  or function(stackdepth)
	return _G.debugstack( (stackdepth or 1)+1, 3, 0):match([[\(.-:%d*[:>]?)]])
	-- return _G.debugstack( (stackdepth or 1)+1, 3, 0):match([[\(.-:.-[:>])]])
end



