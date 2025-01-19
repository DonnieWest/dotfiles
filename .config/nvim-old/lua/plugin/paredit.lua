local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/paredit.fnl"
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
local nvim, paredit = require("aniseed.nvim"), require("nvim-paredit")
do end (_2amodule_locals_2a)["nvim"] = nvim
_2amodule_locals_2a["paredit"] = paredit
paredit.setup({indent = {enabled = true}})
return _2amodule_2a