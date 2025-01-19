local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/startify.fnl"
local _2amodule_name_2a = "plugin.startify"
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
nvim.g.startify_custom_header = {}
nvim.g.startify_change_to_vcs_root = 1
nvim.g.startify_bookmarks = {{c = "~/.config/nvim/init.lua"}}
return _2amodule_2a