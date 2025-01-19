local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/gitsigns.fnl"
local _2amodule_name_2a = "plugin.gitsigns"
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
local gitsigns = require("gitsigns")
do end (_2amodule_locals_2a)["gitsigns"] = gitsigns
gitsigns.setup({signs = {add = {text = "+"}, change = {text = "~"}, delete = {text = "-"}, topdelete = {text = "\226\128\190"}, changedelete = {text = "~-"}, untracked = {text = "\226\148\134"}}})
return _2amodule_2a