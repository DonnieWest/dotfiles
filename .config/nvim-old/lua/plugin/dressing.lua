local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/dressing.fnl"
local _2amodule_name_2a = "plugin.dressing"
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
local dressing, nvim = require("dressing"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["dressing"] = dressing
_2amodule_locals_2a["nvim"] = nvim
dressing.setup({select = {backend = {"telescope", "builtin", "nui"}}})
return _2amodule_2a