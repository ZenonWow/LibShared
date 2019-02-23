local _G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
-- local LibShared = _G[LIBSHARED_NAME] or {}  ;  _G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  GetBuildInfo, geterrorhandler
-- Used from LibShared:
-- Exported to LibShared:  safecall, safecallDynamic, safecallDispatch, errorhandler


-------------------------------------------
--- LibShared.  safecall(unsafeFunc, arg1, arg2, ...)
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
if  not LibShared.safecall  and  _G.select(4, _G.GetBuildInfo()) >= 80000  then

	-- Upvalued Lua globals
	local xpcall = xpcall

	-- Allow hooking _G.geterrorhandler(): don't cache/upvalue it or the errorhandler returned.
	-- Avoid tailcall:  errorhandler() function would show up as "?" in stacktrace, making it harder to understand.
	LibShared.errorhandler = LibShared.errorhandler or  function(errorMessage)  return true and _G.geterrorhandler()(errorMessage)  end
	local errorhandler = LibShared.errorhandler


	LibShared.safecall = function(unsafeFunc, ...)
		-- we check to see if the unsafeFunc passed is actually a function here and don't error when it isn't
		-- this safecall is used for optional functions like OnInitialize OnEnable etc. When they are not
		-- present execution should continue without hinderance
		if  not unsafeFunc  then  return  end
		if  type(unsafeFunc)~='function'  then
			LibShared.softassert(false, "Usage: safecall(unsafeFunc):  function expected, got "..type(unsafeFunc))
			return
		end

		-- 2 pages in 1 line (3 dots).
		return xpcall(unsafeFunc, errorhandler, ...)

	end

	-- No need to load these anymore. Mark them as loaded.
	LibShared.safecallDynamic = LibShared.safecall
	LibShared.safecallDispatch = LibShared.safecall

end


