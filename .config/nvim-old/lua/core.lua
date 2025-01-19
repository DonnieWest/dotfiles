local _2afile_2a = "/home/igneo676/.config/nvim/fnl/core.fnl"
local _2amodule_name_2a = "core"
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
local nvim = require("aniseed.nvim")
do end (_2amodule_locals_2a)["nvim"] = nvim
nvim.ex.autocmd("BufWritePost", "init.vim", "so $MYVIMRC")
nvim.ex.autocmd("VimResized", ":windcmd =")
nvim.ex.autocmd("FocusGained", "*", ":checktime")
local function _1_()
  return vim.highlight.on_yank({higroup = "IncSearch", timeout = 100})
end
vim.api.nvim_create_autocmd({"TextYankPost"}, {callback = _1_})
local function _2_()
  return nvim.fn.setpos(".", nvim.fn.getpos("'\""))
end
vim.api.nvim_create_autocmd({"BufReadPost"}, {desc = "set position after vim loads", callback = _2_})
return _2amodule_2a