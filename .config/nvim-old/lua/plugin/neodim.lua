local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/neodim.fnl"
local _2amodule_name_2a = "plugin.neodim"
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
local neodim, nvim = require("neodim"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["neodim"] = neodim
_2amodule_locals_2a["nvim"] = nvim
neodim.setup({refresh_delay = 75, alpha = 0.75, blend_color = "#000000", hide = {underline = true, virtual_text = true, signs = true}, priority = 100, disable = {}})
return _2amodule_2a