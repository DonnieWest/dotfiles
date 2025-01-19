local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/fidget.fnl"
local _2amodule_name_2a = "plugin.fidget"
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
local fidget, nvim = require("fidget"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["fidget"] = fidget
_2amodule_locals_2a["nvim"] = nvim
fidget.setup({text = {spinner = "dots"}})
return _2amodule_2a