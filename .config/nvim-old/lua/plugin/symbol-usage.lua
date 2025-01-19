local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/symbol-usage.fnl"
local _2amodule_name_2a = "plugin.symbol-usage"
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
local nvim, symbols = require("aniseed.nvim"), require("symbol-usage")
do end (_2amodule_locals_2a)["nvim"] = nvim
_2amodule_locals_2a["symbols"] = symbols
symbols.setup()
return _2amodule_2a