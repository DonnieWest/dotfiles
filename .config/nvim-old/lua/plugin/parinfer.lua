local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/parinfer.fnl"
local _2amodule_name_2a = "plugin.parinfer"
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
local nvim = require("aniseed.nvim")
do end (_2amodule_locals_2a)["nvim"] = nvim
nvim.g.parinfer_no_maps = true
nvim.g.parinfer_enabled = true
nvim.g.parinfer_mode = "paren"
return _2amodule_2a