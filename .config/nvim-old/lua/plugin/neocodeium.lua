local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/neocodeium.fnl"
local _2amodule_name_2a = "plugin.neocodeium"
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
local core, neocodeium, nvim = require("aniseed.core"), require("neocodeium"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["core"] = core
_2amodule_locals_2a["neocodeium"] = neocodeium
_2amodule_locals_2a["nvim"] = nvim
neocodeium.setup({})
vim.keymap.set("i", "<A-f>", neocodeium.accept)
return _2amodule_2a