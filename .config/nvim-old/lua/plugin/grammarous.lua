local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/grammarous.fnl"
local _2amodule_name_2a = "plugin.grammarous"
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
local core, nvim = require("aniseed.core"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["core"] = core
_2amodule_locals_2a["nvim"] = nvim
nvim.g["grammarous#languagetool_cmd"] = "languagetool"
return _2amodule_2a