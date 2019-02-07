local _G, LIBCOMMON_NAME  =  _G, LIBCOMMON_NAME or 'LibCommon'
local LibCommon = _G[LIBCOMMON_NAME]
assert(LibCommon and LibCommon.Require, 'Include "LibCommon.Require.lua" before.')
LibCommon.Require.initmetatable

local LIBCOMMON_REVISION = 1
if (LibCommon.revision or 0) >= LIBCOMMON_REVISION then  return  end

-- GLOBALS:
-- Used from _G:
-- Used from LibCommon:  Require, initmetatable  (only for init)
-- Used from LibCommon:
-- Exported to LibCommon:  name, revision, _metatable
-- Upvalued Lua globals:


-----------------------------
-- Define name, revision, _metatable (pretty printing) for LibCommon.
-- Note: only 1 underscore, in contrast with lua's builtin __metatable with 2 underscores.
--
LibCommon.revision = LIBCOMMON_REVISION
LibCommon.name = LibCommon.name or LIBCOMMON_NAME
LibCommon._metatable = LibCommon.initmetatable(LibCommon)
LibCommon._metatable.__tostring = function(LibCommon)  return (LibCommon.name or LIBCOMMON_NAME).." revision ".._G.tostring(LibCommon.revision)  end

--[[
LibCommon._metatable =  _G.getmetatable(LibCommon)  or  LibCommon._metatable  or  {}
_G.setmetatable(LibCommon, LibCommon._metatable)
--]]


