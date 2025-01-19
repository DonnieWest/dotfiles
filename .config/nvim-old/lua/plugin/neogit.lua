local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/neogit.fnl"
local _2amodule_name_2a = "plugin.neogit"
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
local neogit, nvim = require("neogit"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["neogit"] = neogit
_2amodule_locals_2a["nvim"] = nvim
neogit.setup({disable_context_highlighting = true, integrations = {diffview = true}})
return _2amodule_2a