local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/null.fnl"
local _2amodule_name_2a = "plugin.null"
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
local null, nvim = require("null-ls"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["null"] = null
_2amodule_locals_2a["nvim"] = nvim
null.setup({sources = {null.builtins.formatting.stylua, null.builtins.diagnostics.eslint, null.builtins.completion.spell, require("typescript.extensions.null-ls.code-actions")}})
return _2amodule_2a