local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/octo.fnl"
local _2amodule_name_2a = "plugin.octo"
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
local nvim, octo = require("aniseed.nvim"), require("octo")
do end (_2amodule_locals_2a)["nvim"] = nvim
_2amodule_locals_2a["octo"] = octo
octo.setup({suppress_missing_scope = {projects_v2 = true}})
return _2amodule_2a