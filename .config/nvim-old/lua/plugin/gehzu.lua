local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/gehzu.fnl"
local _2amodule_name_2a = "plugin.gehzu"
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
local nvim, z = require("aniseed.nvim"), require("zest.lib")
do end (_2amodule_locals_2a)["nvim"] = nvim
_2amodule_locals_2a["z"] = z
local function _1_()
  return nvim.ex.autocmd("FileType", "fennel", "nnoremap <silent> <c-]> <cmd>lua require('nvim-gehzu').go_to_definition()<CR>")
end
vim.schedule(_1_)
return _2amodule_2a