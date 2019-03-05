local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

assert(LibShared.initmetatable, 'Include "LibShared.initmetatable.lua" before.')

local LIBSHARED_REVISION = 10
-- Check if full library with same or higher revision is already loaded.
if (LibShared.revision or 0) >= LIBSHARED_REVISION then  return  end

-- GLOBALS:
-- Used from _G:
-- Used from LibShared:  initmetatable  (only for init)
-- Used from LibShared:
-- Exported to LibShared:  name, revision, _metatable
-- Upvalued Lua globals:


-----------------------------
-- Define name, revision, _metatable (pretty printing) for LibShared.
-- Note: only 1 underscore, in contrast with lua's builtin __metatable with 2 underscores.
--
LibShared.revision = LIBSHARED_REVISION
LibShared.name = LibShared.name or LIBSHARED_NAME
LibShared._metatable = LibShared.initmetatable(LibShared)
LibShared._metatable.__tostring = function(LibShared)  return (LibShared.name or LIBSHARED_NAME).." (r"..G.tostring(LibShared.revision)..")"  end

--[[
LibShared._metatable =  G.getmetatable(LibShared)  or  LibShared._metatable  or  {}
G.setmetatable(LibShared, LibShared._metatable)
--]]


