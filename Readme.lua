-- Standard line to reference LibShared in a file -- your file might be the first, therefore the initialization:
local LibShared = _G.LibShared or {}  ;  _G.LibShared = LibShared


-- Alternatives:

-- In two lines if preferred:
local LibShared = _G.LibShared or {}
_G.LibShared = LibShared

-- Init global first -- `local` keyword is not visible at beginning of line:
_G.LibShared = _G.LibShared or {}  ;  local LibShared = LibShared
-- Readable in 2 lines:
_G.LibShared = _G.LibShared or {}
local LibShared = LibShared

-- Non-standard, using global var instead of _G -- does not work as expected in 'strict' addons that change the global environment to the addon environment or a file-local environment:
local LibShared = LibShared or {}  ;  _G.LibShared = LibShared
-- Init global first then local (opposite order), not setting the global LibShared if there was a  `local LibShared`  above:
LibShared = LibShared or {}  ;  local LibShared = LibShared
-- In two lines to make `local` keyword more visible:
LibShared = LibShared or {}
local LibShared = LibShared





Convert LibShared.Define to plain Lua with regular expression search-and-replace:
--
Find what:
LibShared.Define.([^=\n]+) = 
Replace with:
LibShared.\1 = LibShared.\1 or 




