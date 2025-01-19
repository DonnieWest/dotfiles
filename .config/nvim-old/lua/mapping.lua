local _2afile_2a = "/home/igneo676/.config/nvim/fnl/mapping.fnl"
local _2amodule_name_2a = "mapping"
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
local core, nu, nvim = require("aniseed.core"), require("aniseed.nvim.util"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["core"] = core
_2amodule_locals_2a["nu"] = nu
_2amodule_locals_2a["nvim"] = nvim
local function noremap(mode, from, to)
  return nvim.set_keymap(mode, from, to, {noremap = true, silent = true})
end
_2amodule_2a["noremap"] = noremap
nvim.set_keymap("n", "Q", "<nop>", {})
nvim.set_keymap("n", "<space>", "<nop>", {noremap = true})
nvim.g.mapleader = ","
noremap("t", "<Esc>", "<C-\\><C-n>")
noremap("n", "!", ":!")
noremap("n", ";", ":")
noremap("n", "U", ":redo<CR>")
noremap("n", "<Leader>v", ":vsp<CR>")
noremap("n", "<Leader>h", ":sp<CR>")
noremap("n", "<Leader>fr", ":%s/")
noremap("x", "<Leader>fr", ":s/")
noremap("n", "v", "<C-V>")
noremap("n", "<C-V>", "v")
noremap("v", "v", "<C-V>")
noremap("v", "<C-V>", "v")
noremap("v", "<", "<gv")
noremap("v", ">", ">gv")
noremap("n", "<Tab>", ">>_")
noremap("n", "<S-Tab>", "<<_")
noremap("i", "<S-Tab>", "<C-D>")
noremap("v", "<Tab>", ">gv")
noremap("v", "<S-Tab>", "<gv")
noremap("n", "<C-Right>", ":bnext<CR>")
noremap("n", "<C-Left>", ":bprevious<CR>")
noremap("n", "<C-l>", ":bnext<CR>")
noremap("n", "<C-h>", ":bprevious<CR>")
noremap("n", "<Leader>t", ":GrepperRg TODO: <CR>")
noremap("n", "<leader><space>", ":call StripTrailingWhitespace()<cr>")
nu["fn-bridge"]("StripTrailingWhitespace", "mapping", "strip-trailing-whitespace")
local function strip_trailing_whitespace()
  local pos = nvim.fn.getpos(".")
  nvim.command("%s/\\s\\+$//e")
  nvim.command("%s/\\n\\{3,}/\\r\\r/e")
  nvim.command("%s#\\($\\n\\s*\\)\\+\\%$##e")
  return nvim.fn.setpos(".", pos)
end
_2amodule_2a["strip-trailing-whitespace"] = strip_trailing_whitespace
return _2amodule_2a