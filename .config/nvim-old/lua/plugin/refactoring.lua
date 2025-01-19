local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/refactoring.fnl"
local _2amodule_name_2a = "plugin.refactoring"
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
local mapping, nvim, refactoring = require("mapping"), require("aniseed.nvim"), require("refactoring")
do end (_2amodule_locals_2a)["mapping"] = mapping
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["refactoring"] = refactoring
refactoring.setup({})
mapping.noremap("v", "<Leader>rv", ":lua require('refactoring').debug.print_var({})<CR>")
mapping.noremap("n", "<Leader>rp", ":lua require('refactoring').debug.printf({below = false})<CR>")
return _2amodule_2a