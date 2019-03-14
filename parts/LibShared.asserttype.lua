local G, LIBSHARED_NAME  =  _G, LIBSHARED_NAME or 'LibShared'
local LibShared = G[LIBSHARED_NAME] or {}  ;  G[LIBSHARED_NAME] = LibShared

-- GLOBALS:
-- Used from _G:  tonumber
-- Used from LibShared:
-- Exported to LibShared:  asserttype, asserttypeOrNil, asserttypeOrFalse, assertf, assertnf

-- Upvalued Lua globals:
local format,error,type = string.format,error,type


--[[ Copy-paste usage:
asserttype(inputFields, 'table', "Usage: LDB:NewDataObject(name, dataobject):  `dataobject` - ")
--]]


-----------------------------
--- LibShared. asserttype(value, typename, [messagePrefix]):  Raises error (stops execution) if value's type is not the expected `typename`.
-- @param value - to check for type.
-- @param typename (string) - name of expected type.
-- @param messagePrefix (string/nil) - optional error message prefixed to:  "<typename> expected, got <type>"
--
-- Usage:  asserttype(inputFields, 'table', "Usage: LDB:NewDataObject(name, dataobject):  `dataobject` - ")
--
LibShared.asserttype = LibShared.asserttype  or  function(value, typename, messagePrefix, callDepth)
	if type(value)~=typename then  error( (messagePrefix or "")..typename.." expected, got "..type(value), (callDepth or 0)+2 )  end
end


-----------------------------
--- LibShared. asserttypeOrNil(value, typename, [messagePrefix]):  Raises error (stops execution) if value's type is not the expected `typename` and value is not nil.
-- @param value - to check for type.
-- @param typename (string) - name of expected type.
-- @param messagePrefix (string/nil) - optional error message prefixed to:  "<typename> expected, got <type>"
--
LibShared.asserttypeOrNil = LibShared.asserttypeOrNil  or  function(value, typename, messagePrefix, callDepth)
	if nil~=value and type(value)~=typename then  error( (messagePrefix or "")..typename.." or nil expected, got "..type(value), (callDepth or 0)+2 )  end
end


-----------------------------
--- LibShared. asserttypeOrFalse(value, typename, [messagePrefix]):  Raises error (stops execution) if value's type is not the expected `typename` and value is not nil or false.
-- @param value - to check for type.
-- @param typename (string) - name of expected type.
-- @param messagePrefix (string/nil) - optional error message prefixed to:  "<typename> expected, got <type>"
--
LibShared.asserttypeOrFalse = LibShared.asserttypeOrFalse  or  function(value, typename, messagePrefix, callDepth)
	if value and type(value)~=typename then  error( (messagePrefix or "")..typename.." expected, got "..type(value), (callDepth or 0)+2 )  end
end


-----------------------------
--- LibShared. assertf(condition, messageFormat, formatParameter...):  Raises error (stops execution) if condition fails. Formatted error message.
-- @param condition - result of a check that is expected to return a truthy value.
-- @param messageFormat - error message passed to  string.format(), then  error()  if condition fails.
-- Stops execution if condition fails, like  assert().
--
LibShared.assertf = LibShared.assertf  or  function(ok, messageFormat, ...)  if not ok then  error( format(messageFormat, ...), 2 )  end  end
LibShared.assertnf = LibShared.assertnf  or  function(callDepth, ok, messageFormat, ...)
	callDepth = G.tonumber(callDepth)
  if not ok or not callDepth then  error( format(messageFormat, ...), (callDepth or 0)+2 )  end
end


-----------------------------
--- errorf(...)     = assertf(false, ...)


