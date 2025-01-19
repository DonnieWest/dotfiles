local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/tcomment.fnl"
local _2amodule_name_2a = "plugin.tcomment"
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
nvim.fn["tcomment#type#Define"]("kotlin", nvim.fn["tcomment#GetLineC"]("// %s"))
nvim.fn["tcomment#type#Define"]("kotlin_block", nvim.g["tcomment#block_fmt_c"])
nvim.fn["tcomment#type#Define"]("kotlin_inline", nvim.g["tcomment#inline_fmt_c"])
mapping.noremap("n", "<leader>/", ":TComment<CR>")
mapping.noremap("v", "<leader>/", ":TCommentBlock<CR>")
mapping.noremap("n", "gbc", ":TCommentBlock<CR>")
mapping.noremap("v", "gb", ":TCommentBlock<CR>")
return _2amodule_2a