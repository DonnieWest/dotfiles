local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/sayonara.fnl"
local _2amodule_name_2a = "plugin.sayonara"
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
local core, mapping, nvim = require("aniseed.core"), require("mapping"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["core"] = core
_2amodule_locals_2a["mapping"] = mapping
_2amodule_locals_2a["nvim"] = nvim
mapping.noremap("n", "<C-Del>", ":Sayonara<CR>")
mapping.noremap("n", "<ESC>[M", ":Sayonara<CR>")
return _2amodule_2a