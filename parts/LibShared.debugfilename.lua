local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  debugstack
-- Used from LibShared:
-- Exported to LibShared:  debugfilename, debugfileline
-- Upvalued Lua globals:


-----------------------------
LibShared.debugfilename = LibShared.debugfilename  or function(stackdepth)
	-- Allow hooking (replacing) _G.debugstack()
	return _G.debugstack( (stackdepth or 1)+1, 3, 0):match( "\\(.-)[:>]")
end


-----------------------------
LibShared.debugfileline = LibShared.debugfileline  or function(stackdepth)
	return _G.debugstack( (stackdepth or 1)+1, 3, 0):match([[\(.-:%d*[:>]?)]])
	-- return _G.debugstack( (stackdepth or 1)+1, 3, 0):match([[\(.-:.-[:>])]])
end



