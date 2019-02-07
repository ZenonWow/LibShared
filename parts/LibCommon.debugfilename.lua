local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME]
assert(LibCommon and LibCommon.Define, 'Include "LibCommon.Define.lua" before.')

-- GLOBALS:
-- Used from _G:  debugstack
-- Used from LibCommon:
-- Exported to LibCommon:  debugfilename, debugfileline
-- Upvalued Lua globals:


-----------------------------
LibCommon.Define.debugfilename = function(stackdepth)
	-- Allow hooking (replacing) _G.debugstack()
	return _G.debugstack( (stackdepth or 1)+1, 3, 0):match([[\(.-)[:>]]])
end


-----------------------------
LibCommon.Define.debugfileline = function(stackdepth)
	return _G.debugstack( (stackdepth or 1)+1, 3, 0):match([[\(.-:%d*[:>]?)]])
	-- return _G.debugstack( (stackdepth or 1)+1, 3, 0):match([[\(.-:.-[:>])]])
end



