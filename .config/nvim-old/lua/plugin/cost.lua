local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/cost.fnl"
local _2amodule_name_2a = "plugin.cost"
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
local cost, nvim = require("import-cost"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["cost"] = cost
_2amodule_locals_2a["nvim"] = nvim
cost.setup()
return _2amodule_2a