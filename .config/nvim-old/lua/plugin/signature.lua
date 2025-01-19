local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/signature.fnl"
local _2amodule_name_2a = "plugin.signature"
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
local lsp_signature, nvim = require("lsp_signature"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["lsp-signature"] = lsp_signature
_2amodule_locals_2a["nvim"] = nvim
lsp_signature.setup({bind = true, hint_prefix = "", floating_window = false})
return _2amodule_2a