-- Standard line to reference LibCommon in a file -- your file might be the first, therefore the initialization:
local LibCommon = _G.LibCommon or {}  ;  _G.LibCommon = LibCommon


-- Alternatives:

-- In two lines if preferred:
local LibCommon = _G.LibCommon or {}
_G.LibCommon = LibCommon

-- Init global first -- `local` keyword is not visible at beginning of line:
_G.LibCommon = _G.LibCommon or {}  ;  local LibCommon = LibCommon
-- Readable in 2 lines:
_G.LibCommon = _G.LibCommon or {}
local LibCommon = LibCommon

-- Non-standard, using global var instead of _G -- does not work as expected in 'strict' addons that change the global environment to the addon environment or a file-local environment:
local LibCommon = LibCommon or {}  ;  _G.LibCommon = LibCommon
-- Init global first then local (opposite order), not setting the global LibCommon if there was a  `local LibCommon`  above:
LibCommon = LibCommon or {}  ;  local LibCommon = LibCommon
-- In two lines to make `local` keyword more visible:
LibCommon = LibCommon or {}
local LibCommon = LibCommon





Convert LibCommon.Define to plain Lua with regular expression search-and-replace:
--
Find what:
LibCommon.Define.([^=\n]+) = 
Replace with:
LibCommon.\1 = LibCommon.\1 or 




