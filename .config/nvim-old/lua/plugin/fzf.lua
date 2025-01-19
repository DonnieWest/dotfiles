local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/fzf.fnl"
local _2amodule_name_2a = "plugin.fzf"
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
local mapping, nvim = require("mapping"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["mapping"] = mapping
_2amodule_locals_2a["nvim"] = nvim
local function _1_()
  return nvim.ex.autocmd("FileType", "fzf", "tnoremap <buffer> <esc> <c-c>")
end
vim.schedule(_1_)
return _2amodule_2a