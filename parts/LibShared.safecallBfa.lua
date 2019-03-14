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
--- Battle For Azeroth Addon Changes
-- https://us.battle.net/forums/en/wow/topic/20762318007
-- • xpcall now accepts arguments like pcall does
--
-- Lua 5.2 was released on 16 Dec 2011, Bfa on 14 Aug 2018. After 7 years:  2 pages in 1 line.
--
if  not LibShared.safecallBfa  and  G.select(4, G.GetBuildInfo()) >= 80000  then

	-- Upvalued Lua globals:
	local xpcall = xpcall
	-- Used from LibShared:
	G.assert(LibShared.errorhandler, 'Include "LibShared.errorhandler.lua" before.')


	LibShared.safecallBfa = function(unsafeFunc, ...)
		-- we check to see if the unsafeFunc passed is actually a function here and don't error when it isn't
		-- this safecall is used for optional functions like OnInitialize OnEnable etc. When they are not
		-- present execution should continue without hinderance
		if unsafeFunc then
			-- 2 pages in 1 line (3 dots exactly).
			return xpcall(unsafeFunc, LibShared.errorhandler, ...)
		end
	end

	LibShared.safecall = safecallBfa
	LibShared.xpcallArgs = xpcall

	-- No need to load these anymore. Mark them as loaded.
	LibShared.safecallDynamic = LibShared.safecallBfa
	LibShared.safecallForArgNum = LibShared.safecallBfa

end


