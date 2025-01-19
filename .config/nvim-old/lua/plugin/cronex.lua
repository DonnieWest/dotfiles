local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/cronex.fnl"
local _2amodule_name_2a = "plugin.cronex"
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
local core, cronex = require("aniseed.core"), require("cronex")
do end (_2amodule_locals_2a)["core"] = core
_2amodule_locals_2a["cronex"] = cronex
cronex.setup({})
return _2amodule_2a