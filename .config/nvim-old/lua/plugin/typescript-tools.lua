local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/typescript-tools.fnl"
local _2amodule_name_2a = "plugin.typescript-tools"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local mapping, nvim, typescript_tools = require("mapping"), require("aniseed.nvim"), require("typescript-tools")
do end (_2amodule_locals_2a)["mapping"] = mapping
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["typescript-tools"] = typescript_tools
typescript_tools.setup({expose_as_code_action = "all", code_lens = "all"})
return _2amodule_2a