local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/navigator.fnl"
local _2amodule_name_2a = "plugin.navigator"
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
local core, mapping, nvim = require("aniseed.core"), require("mapping"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["core"] = core
_2amodule_locals_2a["mapping"] = mapping
_2amodule_locals_2a["nvim"] = nvim
nvim.g.tmux_navigator_no_mappings = 1
mapping.noremap("n", "<M-Left>", ":TmuxNavigateLeft<CR>")
mapping.noremap("n", "<M-Down>", ":TmuxNavigateDown<CR>")
mapping.noremap("n", "<Alt-Down>", ":TmuxNavigateDown<CR>")
mapping.noremap("n", "<M-Up>", ":TmuxNavigateUp<CR>")
mapping.noremap("n", "<M-Right>", ":TmuxNavigateRight<CR>")
mapping.noremap("n", "<C-W>k", ":TmuxNavigateUp<CR>")
mapping.noremap("n", "<C-W>j", ":TmuxNavigateDown<CR>")
mapping.noremap("n", "<C-W>h", ":TmuxNavigateLeft<CR>")
mapping.noremap("n", "<C-W>l", ":TmuxNavigateRight<CR>")
mapping.noremap("t", "<M-Left>", "<C-\\><C-n>:TmuxNavigateLeft<CR>")
mapping.noremap("t", "<M-Down>", "<C-\\><C-n>:TmuxNavigateDown<CR>")
mapping.noremap("t", "<Alt-Down>", "<C-\\><C-n>:TmuxNavigateDown<CR>")
mapping.noremap("t", "<M-Up>", "<C-\\><C-n>:TmuxNavigateUp<CR>")
mapping.noremap("t", "<M-Right>", "<C-\\><C-n>:TmuxNavigateRight<CR>")
mapping.noremap("t", "<C-W>k", "<C-\\><C-n>:TmuxNavigateUp<CR>")
mapping.noremap("t", "<C-W>j", "<C-\\><C-n>:TmuxNavigateDown<CR>")
mapping.noremap("t", "<C-W>h", "<C-\\><C-n>:TmuxNavigateLeft<CR>")
mapping.noremap("t", "<C-W>l", "<C-\\><C-n>:TmuxNavigateRight<CR>")
return _2amodule_2a