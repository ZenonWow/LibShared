local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
-- local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  GetBuildInfo, assert
-- Used from LibShared:  errorhandler
-- Exported to LibShared:  safecall, safecallDynamic, safecallDispatch


-------------------------------------------
--- LibShared. safecall(unsafeFunc, arg1, arg2, ...)
--
-- Similar to pcall(unsafeFunc, arg1, arg2, ...)
-- with proper errorhandler while executing unsafeFunc.
--
LibShared.safecall = LibShared.safecallBfa
	or LibShared.safecallDynamic
	or LibShared.safecallForArgNum

LibShared.xpcallArgs = LibShared.xpcallArgs
	or LibShared.xpcallDynamic
	or LibShared.xpcallForArgNum


