local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/leap.fnl"
local _2amodule_name_2a = "plugin.leap"
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
local leap, nvim = require("leap"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["leap"] = leap
_2amodule_locals_2a["nvim"] = nvim
leap.add_default_mappings()
return _2amodule_2a